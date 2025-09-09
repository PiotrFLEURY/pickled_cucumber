import 'dart:collection';
import 'dart:mirrors';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:pickled_cucumber/pickled_cucumber.dart';
import 'package:pickled_cucumber/src/model.dart';
import 'package:pickled_cucumber/src/regexp.dart';
import 'package:pickled_cucumber/src/test_code_builder.dart';
import 'package:test/test.dart';

///
/// Engine class to run Cucumber tests with Dart
///
/// Example:
///
/// ```dart
/// import 'package:pickled_cucumber/pickled_cucumber.dart';
///
/// class StepDefs {
///
///   @Given('I have {int} "cukes" in my {string}')
///   void iHaveCukesInMyBelly(int cukes, String belly) {
///     print('Cukes: $cukes');
///     print('Belly: $belly');
///   }
///
///   @When('I wait {int} hour')
///   void iWaitHour(int hour) {
///     print('Hour: $hour');
///   }
///
///   @Then('my belly should growl')
///   void myBellyShouldGrowl() {
///     print('Growl!');
///   }
///
///   @And('I should have indigestion')
///   void iShouldHaveIndigestion() {
///     print('Indigestion!');
///   }
///
/// }
///
/// void main() {
///   PickledCucumber.runFeatures('features', StepDefs());
/// }
///
/// ```
/// Featrure:
///
///   Feature: Eating cukes makes me full
///     Given I have 42 "cukes" in my "belly"
///     When I wait 1 hour
///     Then my belly should growl
///     And I should have indigestion
///
/// ```
class PickledCucumber {
  ///
  /// Runs all feature files in a directory
  /// [featureDirectoryPath] is the path to the directory containing the feature files
  /// [stepDefs] is the instance of the class containing the step definitions
  /// [fileSystem] is the file system to use
  /// [testMethod] is the test method to use
  /// Example:
  /// ```dart
  /// PickledCucumber.runFeatures('features', StepDefs());
  /// ```
  ///
  (int success, int failing) runFeatures(
    String featureDirectoryPath,
    dynamic stepDefs, {
    FileSystem fileSystem = const LocalFileSystem(),
    Function testMethod = test,
    TestCodeBuilder? codeBuilder,
  }) {
    final stepDefsMirror = reflect(stepDefs);

    List<Feature> features = parseFeatures(
      fileSystem,
      featureDirectoryPath,
    );

    int success = 0;
    int failing = 0;
    for (final feature in features) {
      final report = runFeature(
        feature,
        stepDefsMirror,
        testMethod,
        codeBuilder: codeBuilder,
      );
      success += report.$1;
      failing += report.$2;
    }
    return (success, failing);
  }

  // recursive function to parse all feature files in a directory and subdirectories

  List<Feature> parseFeatures(FileSystem fileSystem, featureDirectoryPath) {
    final featureDirectory = fileSystem.directory(featureDirectoryPath);
    final featureFiles = featureDirectory
        .listSync(recursive: true)
        .where(
          (file) => file.path.endsWith('.feature'),
        )
        .toList();
    final features = readFeatureFiles(
      fileSystem,
      featureFiles,
    );
    return features;
  }

  ///
  /// Runs a single feature file
  /// [featureFile] is the the feature file
  /// [stepDefs] is the mirror of the class containing the step definitions
  /// [testMethod] is the test method to use
  /// Example:
  /// ```dart
  /// PickledCucumber.runFeatureFile('features/feature.feature', StepDefs());
  /// ```
  (int success, int failing) runFeature(
    Feature feature,
    stepDefs,
    Function testMethod, {
    TestCodeBuilder? codeBuilder,
  }) {
    // Parse the step definitions class to get all the invokable methods
    Map<String, MethodMirror> allMembers = _parseMembers(stepDefs);

    int success = 0;
    int failing = 0;
    for (var scenario in feature.scenarios) {
      final pass = _runScenario(
        scenario,
        allMembers,
        stepDefs,
        testMethod,
      );
      if (pass) {
        success++;
      } else {
        failing++;
      }
    }
    return (success, failing);
  }

  ///
  /// Reads all feature files in a directory and returns a list of [Feature] objects
  ///
  List<Feature> readFeatureFiles(
    FileSystem fileSystem,
    List<FileSystemEntity> files,
  ) {
    return files.map((file) {
      final featureFile = fileSystem.file(file.path);
      return _readFeatureFile(featureFile);
    }).toList();
  }

  ///
  /// Reads a feature file and returns a [Feature] object
  /// [featureFile] is the the feature file
  /// Example:
  /// ```dart
  /// Feature feature = PickledCucumber.readFeatureFile('features/feature.feature');
  /// ```
  ///
  Feature _readFeatureFile(File featureFile) {
    final featureLines = featureFile.readAsLinesSync();
    final feature = Feature.fromFeature(featureLines);
    return feature;
  }

  ///
  /// Parses the step definitions class and returns a map of all the methods
  /// [stepDefs] is the instance of the class containing the step definitions
  /// Example:
  /// ```dart
  /// Map<String, MethodMirror> allMembers = PickledCucumber.parseMembers(stepDefs);
  /// ```
  ///
  Map<String, MethodMirror> _parseMembers(InstanceMirror stepDefs) {
    final allMembers = <String, MethodMirror>{};
    for (final member in stepDefs.type.instanceMembers.values) {
      final metadata = member.metadata;
      for (final meta in metadata) {
        if (meta.reflectee is GherkinAnnotation) {
          allMembers[meta.reflectee.value] = member;
        }
      }
    }

    return allMembers;
  }

  ///
  /// Runs a single scenario
  /// [scenario] is the scenario to run
  /// [allMembers] is a map of all the methods
  /// [stepDefs] is the instance of the class containing the step definitions
  /// [testMethod] is the test method to use
  ///
  bool _runScenario(
    Scenario scenario,
    Map<String, MethodMirror> allMembers,
    InstanceMirror stepDefs,
    Function testMethod,
  ) {
    try {
      // Run a Unit Test for each scenario
      testMethod(scenario.name, () {
        for (var step in scenario.steps) {
          _runStep(
            scenario.name,
            step,
            allMembers,
            stepDefs,
          );
        }
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  ///
  /// Runs a single step
  /// [scenarioName] is the name of the scenario
  /// [step] is the step to run
  /// [allMembers] is a map of all the methods
  /// [stepDefs] is the instance of the class containing the step definitions
  ///
  void _runStep(
    String scenarioName,
    String step,
    Map<String, MethodMirror> allMembers,
    InstanceMirror stepDefs,
  ) {
    print(step);

    for (var possibleStep in CucumberRegex.possibleSteps) {
      if (possibleStep.hasMatch(step)) {
        String sanitizedStep = sanytizeStep(step);
        final match = possibleStep.firstMatch(sanitizedStep);
        final method = allMembers[match!.group(1)!.trim()];

        if (method == null) {
          throw Exception('Not Step Definition found for: $step');
        }

        List<dynamic> orderedArguments = extractOrderedArguments(
          sanitizedStep,
          step,
        );

        stepDefs.invoke(method.simpleName, orderedArguments);
      }
    }
  }

  String sanytizeStep(String step) {
    final sanitizedStep = step
        .replaceAll(CucumberRegex.string, '{string}')
        .replaceAll(CucumberRegex.float, ' {float}')
        .replaceAll(CucumberRegex.int, ' {int}')
        .trim();
    return sanitizedStep;
  }

  ///
  /// Extracts the ordered arguments from a step
  /// [sanitizedStep] is the step with the placeholders
  /// [step] is the step with the values
  ///
  List<dynamic> extractOrderedArguments(
    String sanitizedStep,
    String step,
  ) {
    final sanitizedStepWords = sanitizedStep.trim().split(' ');
    final orderedArguments = [];

    final stringMatches = CucumberRegex.string.allMatches(step);
    final floatMatches = CucumberRegex.float.allMatches(
      step.replaceAll(
        CucumberRegex.string,
        '',
      ),
    );
    final intMatches = CucumberRegex.int.allMatches(
      step
          .replaceAll(
            CucumberRegex.string,
            '',
          )
          .replaceAll(
            CucumberRegex.float,
            '',
          ),
    );

    final stringLifo = Queue.from(
      stringMatches.map(
        (e) => e.group(1)!.replaceAll(
              '"',
              '',
            ),
      ),
    );
    final floatLifo = Queue.from(
      floatMatches.map(
        (e) => double.parse(
          e.group(1)!,
        ),
      ),
    );
    final intLifo = Queue.from(
      intMatches.map(
        (e) => int.parse(
          e.group(1)!,
        ),
      ),
    );

    for (var i = 0; i < sanitizedStepWords.length; i++) {
      final sanitizedStepWord = sanitizedStepWords[i];
      switch (sanitizedStepWord) {
        case '{string}':
          orderedArguments.add(stringLifo.removeFirst());
          break;
        case '{int}':
          orderedArguments.add(intLifo.removeFirst());
          break;
        case '{float}':
          orderedArguments.add(floatLifo.removeFirst());
          break;
      }
    }
    return orderedArguments;
  }
}

import 'dart:mirrors';

import 'package:cucumber_dart/cucumber_dart.dart';
import 'package:cucumber_dart/src/model.dart';
import 'package:cucumber_dart/src/regexp.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:test/test.dart';

///
/// Engine class to run Cucumber tests with Dart
///
/// Example:
///
/// ```dart
/// import 'package:cucumber_dart/cucumber_dart.dart';
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
///   CucumberDart.runFeatures('features', StepDefs());
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
class CucumberDart {
  ///
  /// Runs all feature files in a directory
  /// [featureDirectoryPath] is the path to the directory containing the feature files
  /// [stepDefs] is the instance of the class containing the step definitions
  /// [fileSystem] is the file system to use
  /// [testMethod] is the test method to use
  /// Example:
  /// ```dart
  /// CucumberDart.runFeatures('features', StepDefs());
  /// ```
  ///
  static (int success, int failing) runFeatures(
    featureDirectoryPath,
    stepDefs, {
    FileSystem fileSystem = const LocalFileSystem(),
    Function testMethod = test,
  }) {
    final featureDirectory = fileSystem.directory(featureDirectoryPath);
    final featureFiles = featureDirectory.listSync().where(
          (file) => file.path.endsWith('.feature'),
        );
    int success = 0;
    int failing = 0;
    for (final featureFile in featureFiles) {
      final report = runFeatureFile(
        fileSystem.file(featureFile.path),
        stepDefs,
        testMethod,
      );
      success += report.$1;
      failing += report.$2;
    }
    return (success, failing);
  }

  ///
  /// Runs a single feature file
  /// [featureFile] is the the feature file
  /// [stepDefsInstance] is the instance of the class containing the step definitions
  /// [testMethod] is the test method to use
  /// Example:
  /// ```dart
  /// CucumberDart.runFeatureFile('features/feature.feature', StepDefs());
  /// ```
  static (int success, int failing) runFeatureFile(
    File featureFile,
    stepDefsInstance,
    Function testMethod,
  ) {
    Feature feature = _readFeatureFile(featureFile);
    final stepDefs = reflect(stepDefsInstance);

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
  /// Reads a feature file and returns a [Feature] object
  /// [featureFile] is the the feature file
  /// Example:
  /// ```dart
  /// Feature feature = CucumberDart.readFeatureFile('features/feature.feature');
  /// ```
  ///
  static Feature _readFeatureFile(File featureFile) {
    final featureLines = featureFile.readAsLinesSync();
    final feature = Feature.fromFeature(featureLines);
    return feature;
  }

  ///
  /// Parses the step definitions class and returns a map of all the methods
  /// [stepDefs] is the instance of the class containing the step definitions
  /// Example:
  /// ```dart
  /// Map<String, MethodMirror> allMembers = CucumberDart.parseMembers(stepDefs);
  /// ```
  ///
  static Map<String, MethodMirror> _parseMembers(InstanceMirror stepDefs) {
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
  static bool _runScenario(
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
  /// [step] is the step to run
  /// [allMembers] is a map of all the methods
  /// [stepDefs] is the instance of the class containing the step definitions
  ///
  static void _runStep(
    String step,
    Map<String, MethodMirror> allMembers,
    InstanceMirror stepDefs,
  ) {
    print(step);

    for (var possibleStep in CucumberRegex.possibleSteps) {
      if (possibleStep.hasMatch(step)) {
        final sanitizedStep = step
            .replaceAll(CucumberRegex.string, '{string}')
            .replaceAll(CucumberRegex.float, ' {float}')
            .replaceAll(CucumberRegex.int, ' {int}')
            .trim();
        final match = possibleStep.firstMatch(sanitizedStep);
        final method = allMembers[match!.group(1)!.trim()];

        if (method == null) {
          throw Exception('Not Step Definition found for: $step');
        }

        List<dynamic> orderedArguments = _extractOrderedArguments(
          sanitizedStep,
          step,
        );

        stepDefs.invoke(method.simpleName, orderedArguments);
      }
    }
  }

  ///
  /// Extracts the ordered arguments from a step
  /// [sanitizedStep] is the step with the placeholders
  /// [step] is the step with the values
  ///
  static List<dynamic> _extractOrderedArguments(
    String sanitizedStep,
    String step,
  ) {
    final sanitizedStepWords = sanitizedStep.trim().split(' ');
    final stepWords = step.trim().split(' ');
    final orderedArguments = [];

    for (var i = 0; i < sanitizedStepWords.length; i++) {
      final sanitizedStepWord = sanitizedStepWords[i];
      switch (sanitizedStepWord) {
        case '{string}':
          orderedArguments.add(stepWords[i].replaceAll('"', ''));
          break;
        case '{int}':
          orderedArguments.add(int.parse(stepWords[i]));
          break;
        case '{float}':
          orderedArguments.add(double.parse(stepWords[i]));
          break;
      }
    }
    return orderedArguments;
  }
}

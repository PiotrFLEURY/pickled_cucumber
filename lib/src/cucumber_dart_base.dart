import 'dart:io';
import 'dart:mirrors';

import 'package:cucumber_dart/cucumber_dart.dart';
import 'package:cucumber_dart/src/model.dart';
import 'package:cucumber_dart/src/regexp.dart';
import 'package:test/test.dart';

class CucumberDart {

  static void runFeatures(featureDirectoryPath, stepDefs) {
    final featureDirectory = Directory(featureDirectoryPath);
    final featureFiles = featureDirectory.listSync().where(
          (file) => file.path.endsWith('.feature'),
        );
    for (final featureFile in featureFiles) {
      runFeatureFile(featureFile.path, stepDefs);
    }
  }

  static void runFeatureFile(featureFilePath, stepDefsInstance) {
    // Read feature yaml file
    final featureLines = File(featureFilePath).readAsLinesSync();
    final feature = Feature.fromFeature(featureLines);
    final stepDefs = reflect(stepDefsInstance);

    Map<String, MethodMirror> allMembers = _parseMembers(stepDefs);

    final possibleSteps = [
      CucumberRegex.givenStep,
      CucumberRegex.whenStep,
      CucumberRegex.thenStep,
      CucumberRegex.andStep,
      CucumberRegex.butStep,
    ];

    for (var scenario in feature.scenarios) {
      _runScenario(
        scenario,
        possibleSteps,
        allMembers,
        stepDefs,
      );
    }
  }

  static Map<String, MethodMirror> _parseMembers(InstanceMirror stepDefs) {
    final givenMembers = <String, MethodMirror>{};
    final whenMembers = <String, MethodMirror>{};
    final thenMembers = <String, MethodMirror>{};
    final andMembers = <String, MethodMirror>{};
    final butMembers = <String, MethodMirror>{};
    for (final member in stepDefs.type.instanceMembers.values) {
      final metadata = member.metadata;
      for (final meta in metadata) {
        if (meta.reflectee is Given) {
          givenMembers[meta.reflectee.value] = member;
        }
        if (meta.reflectee is When) {
          whenMembers[meta.reflectee.value] = member;
        }
        if (meta.reflectee is Then) {
          thenMembers[meta.reflectee.value] = member;
        }
        if (meta.reflectee is And) {
          andMembers[meta.reflectee.value] = member;
        }
        if (meta.reflectee is But) {
          butMembers[meta.reflectee.value] = member;
        }
      }
    }

    final allMembers = {
      ...givenMembers,
      ...whenMembers,
      ...thenMembers,
      ...andMembers,
      ...butMembers,
    };
    return allMembers;
  }

  static void _runScenario(
    Scenario scenario,
    List<RegExp> possibleSteps,
    Map<String, MethodMirror> allMembers,
    InstanceMirror stepDefs,
  ) {
    test(scenario.name, () {
      for (var step in scenario.steps) {
        _runStep(
          step,
          possibleSteps,
          allMembers,
          stepDefs,
        );
      }
    });
  }

  static void _runStep(
    String step,
    List<RegExp> possibleSteps,
    Map<String, MethodMirror> allMembers,
    InstanceMirror stepDefs,
  ) {
    print(step);

    for (var possibleStep in possibleSteps) {
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

  static List<dynamic> _extractOrderedArguments(
      String sanitizedStep, String step) {
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

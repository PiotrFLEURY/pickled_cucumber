import 'package:cucumber_dart/src/regexp.dart';

///
/// Dart representation of the Gherkin scenario
///
class Scenario {
  /// The name of the scenario
  final String name;

  /// The steps of the scenario
  final List<String> steps;

  /// Creates a new instance of [Scenario]
  Scenario(this.name, this.steps);
}

///
/// Dart representation of the Gherkin feature
///
class Feature {
  /// The name of the feature
  final String name;

  /// The scenarios of the feature
  final List<Scenario> scenarios;

  /// Creates a new instance of [Feature]
  Feature(this.name, this.scenarios);

  ///
  /// Parses a feature from a list of lines
  /// [featureLines] is the list of lines to parse
  ///
  /// Example:
  /// ```gherkin
  ///
  /// Feature: My feature
  ///
  ///   Scenario: My scenario
  ///     Given I have a step
  ///     When I have another step
  ///     Then I have a third step
  /// ```
  ///
  /// ```dart
  /// Feature feature = Feature.fromFeature(featureLines);
  /// ```
  ///
  factory Feature.fromFeature(List<String> featureLines) {
    final name = featureLines.first.split(':')[1].trim();
    final scenarios = <Scenario>[];

    Scenario? currentScenario;

    for (var line in featureLines.skip(1)) {
      if (CucumberRegex.scenario.hasMatch(line)) {
        currentScenario = Scenario(line.split(':')[1], []);
        scenarios.add(currentScenario);
      } else if (currentScenario != null && line.trim().isNotEmpty) {
        currentScenario.steps.add(line);
      }
    }
    return Feature(name, scenarios);
  }
}

class StepMethod {
  final String stepName;
  final String methodName;

  StepMethod(
    this.stepName,
    this.methodName,
  );
}

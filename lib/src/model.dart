import 'package:cucumber_dart/src/regexp.dart';

class Scenario {
  final String name;
  final List<String> steps;

  Scenario(this.name, this.steps);
}

class Feature {
  final String name;
  final List<Scenario> scenarios;

  Feature(this.name, this.scenarios);

  factory Feature.fromFeature(List<String> featureLines) {
    final name = featureLines.first.split(':')[1].trim();
    final scenarios = <Scenario>[];

    Scenario? currentScenario;

    for (var line in featureLines.skip(1)) {
      if (CucumberRegex.scenario.hasMatch(line)) {
        currentScenario = Scenario(line.split(':')[1], []);
        scenarios.add(currentScenario);
      } else if (currentScenario != null) {
        currentScenario.steps.add(line);
      }
    }
    return Feature(name, scenarios);
  }
}
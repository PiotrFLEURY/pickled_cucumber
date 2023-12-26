import 'package:cucumber_dart/cucumber_dart.dart';

import 'step_definitions.dart';

void main() {
  CucumberDart().runFeatures(
    'test/features/',
    DartFrogStepDefinition(),
  );
}

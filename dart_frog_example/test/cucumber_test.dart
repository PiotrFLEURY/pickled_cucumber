import 'package:pickled_cucumber/pickled_cucumber.dart';

import 'step_definitions.dart';

void main() {
  PickledCucumber().runFeatures(
    'test/features/',
    DartFrogStepDefinition(),
  );
}

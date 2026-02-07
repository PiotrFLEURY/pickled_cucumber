import 'package:flutter_test/flutter_test.dart';

import 'counter_step_definitions.pickled.dart' as counter;
import 'math_step_definitions.pickled.dart' as math;
import 'jira_step_definitions.pickled.dart' as jira;
import 'background_account_step_definitions.pickled.dart' as background;
import 'library_step_definitions.pickled.dart' as library_steps;
import 'only_parameter_step_definitions.pickled.dart' as only_parameter;

void main() {
  group('Counter', () {
    counter.runFeatures();
  });
  group('Math', () {
    math.runFeatures();
  });
  group('Jira', () {
    jira.runFeatures();
  });
  group('Background Account', () {
    background.runFeatures();
  });
  group('Library', () {
    library_steps.runFeatures();
  });
  group('Only Parameter', () {
    only_parameter.runFeatures();
  });
}

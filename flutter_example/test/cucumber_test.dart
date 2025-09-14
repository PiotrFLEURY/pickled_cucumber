import 'package:flutter_test/flutter_test.dart';

import 'counter_step_definitions.pickled.dart' as counter;
import 'math_step_definitions.pickled.dart' as math;
import 'jira_step_definitions.pickled.dart' as jira;
import 'background_account_step_definitions.pickled.dart' as background;

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
}

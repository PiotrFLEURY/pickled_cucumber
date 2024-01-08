import 'package:integration_test/integration_test.dart';

import '../test/counter_step_definitions.pickled.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  runFeatures();
}

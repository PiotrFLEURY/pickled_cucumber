import 'package:pickled_cucumber/src/pickled_cucumber_base.dart';
import 'package:dart_example/pickled_cucumber_example.dart';

main() {
  PickledCucumber().runFeatures(
    'test/features/',
    ExampleStepDefinitions(),
  );
}

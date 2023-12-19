import 'package:cucumber_dart/src/cucumber_dart_base.dart';
import '../cucumber_dart_example.dart';

main() {
  CucumberDart().runFeatures(
    'test/features/',
    ExampleStepDefinitions(),
  );
}

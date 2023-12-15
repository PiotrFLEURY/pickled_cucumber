import 'package:cucumber_dart/cucumber_dart.dart';

import '../cucumber_dart_example.dart';

main() {
  final stepDefsDartFile = ExampleStepDefinitions();

  CucumberDart.runFeatures(
    'example/features/',
    stepDefsDartFile,
  );
}
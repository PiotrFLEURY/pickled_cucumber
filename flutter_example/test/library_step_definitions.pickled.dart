// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'library_step_definitions.dart';

runFeatures() {
  final steps = LibraryStepDefinitions();
  group(
    'A library file with multiple classes should generate pickled cucumber step methods',
    () {
      testWidgets(
        'A library file with multiple classes should generate pickled cucumber step methods',
        (WidgetTester widgetTester) async {
          await steps.aLibraryFileWithMultipleClassesAndStepDefinitions(
            widgetTester,
            2,
          );
          await steps.iResolveTheStepMethodsFromTheLibraryFile(widgetTester);
          await steps
              .iShouldGetAListOfStepMethodsThatIncludesTheMethodFromTheFirstClass(
            widgetTester,
          );
        },
      );
    },
  );
}

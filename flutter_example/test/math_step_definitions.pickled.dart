// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'math_step_definitions.dart';

runFeatures() {
  final steps = MathSteps();
  group('Math', () {
    testWidgets('Add two numbers', (WidgetTester widgetTester) async {
      await steps.iHaveEntered(widgetTester, 50);
      await steps.iHaveEnteredAgain(widgetTester, 70);
      await steps.iPressAdd(widgetTester);
      await steps.theResultShouldBe(widgetTester, 120);
    });
  });
}

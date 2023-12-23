// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'counter_step_definitions.dart';

runFeatures() {
  final steps = CounterSteps();
  group(
    'counter',
    () {
      testWidgets(
        ' increment counter',
        (WidgetTester widgetTester) async {
          await steps.counterIs(
            widgetTester,
            0,
          );
          await steps.iIncrementCounter(widgetTester);
          await steps.counterShouldBe(
            widgetTester,
            1,
          );
        },
      );
      testWidgets(
        ' increment counter twice',
        (WidgetTester widgetTester) async {
          await steps.counterIs(
            widgetTester,
            0,
          );
          await steps.iIncrementCounterTwice(widgetTester);
          await steps.counterShouldBe(
            widgetTester,
            2,
          );
        },
      );
      testWidgets(
        ' increment counter ten times',
        (WidgetTester widgetTester) async {
          await steps.counterIs(
            widgetTester,
            0,
          );
          await steps.iIncrementCounterTimes(
            widgetTester,
            10,
          );
          await steps.counterShouldBe(
            widgetTester,
            10,
          );
        },
      );
    },
  );
}

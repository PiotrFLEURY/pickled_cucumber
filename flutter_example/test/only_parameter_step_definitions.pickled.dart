// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'only_parameter_step_definitions.dart';

runFeatures() {
  final steps = OnlyParameterStepDefinition();
  group('Only parameters', () {
    testWidgets('Only parameters', (WidgetTester widgetTester) async {
      await steps.iHaveAParameter(widgetTester, 'param1');
      await steps.iUseTheParameter(widgetTester, 'param1');
      await steps.iShouldSeeTheParameterInTheReport(widgetTester, 'param1');
    });
  });
}

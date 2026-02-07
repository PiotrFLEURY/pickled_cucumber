// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'jira_step_definitions.dart';

runFeatures() {
  final steps = JiraSteps();
  group('Jira', () {
    testWidgets('Scenario with Jira ticket', (WidgetTester widgetTester) async {
      await steps.iHaveAScenarioWithJiraTicket(widgetTester);
      await steps.iLinkJiraTicketToTheScenario(widgetTester);
      await steps.iShouldSeeJiraTicketInTheReport(widgetTester);
    });
    testWidgets('Second scenario with Jira ticket', (
      WidgetTester widgetTester,
    ) async {
      await steps.iHaveAScenarioWithJiraTicket(widgetTester);
      await steps.iLinkJiraTicketToTheScenario(widgetTester);
      await steps.iShouldSeeJiraTicketInTheReport(widgetTester);
    });
  });
}

import 'package:pickled_cucumber/src/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

@StepDefinition()
class JiraSteps {
  @Given('I have a scenario with Jira ticket')
  Future<void> iHaveAScenarioWithJiraTicket(WidgetTester tester) async {
    // Do nothing
  }

  @When('I link Jira ticket to the scenario')
  Future<void> iLinkJiraTicketToTheScenario(WidgetTester tester) async {
    // Do nothing
  }

  @Then('I should see Jira ticket in the report')
  Future<void> iShouldSeeJiraTicketInTheReport(WidgetTester tester) async {
    // Do nothing
  }
}

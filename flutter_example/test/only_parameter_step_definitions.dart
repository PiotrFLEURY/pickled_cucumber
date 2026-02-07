import 'package:flutter_test/flutter_test.dart';
import 'package:pickled_cucumber/src/annotations.dart';

@StepDefinition()
class OnlyParameterStepDefinition {
  @Given('I have a parameter {string}')
  Future<void> iHaveAParameter(WidgetTester tester, String param) async {
    // This step is intentionally left empty to test that steps with only parameters are generated correctly.
  }

  @When('I use the parameter {string}')
  Future<void> iUseTheParameter(WidgetTester tester, String param) async {
    // This step is intentionally left empty to test that steps with only parameters are generated correctly.
  }

  @Then('I should see the parameter {string} in the report')
  Future<void> iShouldSeeTheParameterInTheReport(
      WidgetTester tester, String param) async {
    // This step is intentionally left empty to test that steps with only parameters are generated correctly.
  }
}

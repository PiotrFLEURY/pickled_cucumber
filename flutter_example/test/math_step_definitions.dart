import 'package:flutter/widgets.dart';
import 'package:pickled_cucumber/src/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

@StepDefinition()
class MathSteps {
  // Given I have entered 50 into the calculator
  @Given('I have entered {int} into the calculator')
  Future<void> iHaveEntered(WidgetTester tester, int number) async {
    debugPrint('I have entered $number into the calculator');
  }

  // And I have entered 70 into the calculator
  @And('I have entered {int} into the calculator')
  Future<void> iHaveEnteredAgain(WidgetTester tester, int number) async {
    debugPrint('I have entered $number into the calculator');
  }

  // When I press add
  @When('I press add')
  Future<void> iPressAdd(WidgetTester tester) async {
    debugPrint('I press add');
  }

  // Then the result should be 120 on the screen
  @Then('the result should be {int} on the screen')
  Future<void> theResultShouldBe(WidgetTester tester, int result) async {
    debugPrint('the result should be $result on the screen');
  }
}

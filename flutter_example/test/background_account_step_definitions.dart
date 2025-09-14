import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pickled_cucumber/src/annotations.dart';

@StepDefinition()
class BackgroundAccountStepDefinitions {
  @Given('I am on the splash screen without values')
  Future<void> iAmOnTheSplashScreenWithoutValues(WidgetTester tester) async {
    debugPrint('Background: I am on the splash screen without values');
  }

  @And('I redirected to the login page')
  Future<void> iRedirectedToTheLoginPage(WidgetTester tester) async {
    debugPrint('Background: I redirected to the login page');
  }

  @And('I want to create an account')
  Future<void> iWantToCreateAnAccount(WidgetTester tester) async {
    debugPrint('Background: I want to create an account');
  }

  @And('I should be redirected to the create account page')
  Future<void> iShouldBeRedirectedToTheCreateAccountPage(
      WidgetTester tester) async {
    debugPrint('Background: I should be redirected to the create account page');
  }

  @When('I fill in the form with valid data')
  Future<void> iFillInTheFormWithValidData(WidgetTester tester) async {
    debugPrint('Scenario: I fill in the form with valid data');
  }

  @When('I fill in the form with invalid email')
  Future<void> iFillInTheFormWithInvalidEmail(WidgetTester tester) async {
    debugPrint('Scenario: I fill in the form with invalid email');
  }

  @And('I click on create account button')
  Future<void> iClickOnCreateAccountButton(WidgetTester tester) async {
    debugPrint('Scenario: I click on create account button');
  }

  @Then('I should be redirected to the select team page')
  Future<void> iShouldBeRedirectedToTheSelectTeamPage(
      WidgetTester tester) async {
    debugPrint('Scenario: I should be redirected to the select team page');
  }

  @Then('I should see an error message')
  Future<void> iShouldSeeAnErrorMessage(WidgetTester tester) async {
    debugPrint('Scenario: I should see an error message');
  }

  @When('I fill in the form with email {string}')
  Future<void> iFillInTheFormWithEmail(
    WidgetTester tester,
    String email,
  ) async {
    debugPrint('Scenario: I fill in the form with email $email');
  }
}

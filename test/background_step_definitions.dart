import 'package:pickled_cucumber/pickled_cucumber.dart';

@StepDefinition()
class BackgroundStepDefinitions {
  @Given('I am on the splash screen without values')
  Future<void> iAmOnTheSplashScreenWithoutValues(dynamic tester) async {
    // Implementation pour aller à l'écran splash
    print('Background: I am on the splash screen without values');
  }

  @And('I redirected to the login page')
  Future<void> iRedirectedToTheLoginPage(dynamic tester) async {
    // Implementation pour rediriger vers la page de connexion
    print('Background: I redirected to the login page');
  }

  @And('I want to create an account')
  Future<void> iWantToCreateAnAccount(dynamic tester) async {
    // Implementation pour vouloir créer un compte
    print('Background: I want to create an account');
  }

  @And('I should be redirected to the create account page')
  Future<void> iShouldBeRedirectedToTheCreateAccountPage(dynamic tester) async {
    // Implementation pour être redirigé vers la page de création de compte
    print('Background: I should be redirected to the create account page');
  }

  @When('I fill in the form with valid data')
  Future<void> iFillInTheFormWithValidData(dynamic tester) async {
    // Implementation pour remplir le formulaire avec des données valides
    print('Scenario: I fill in the form with valid data');
  }

  @When('I fill in the form with invalid email')
  Future<void> iFillInTheFormWithInvalidEmail(dynamic tester) async {
    // Implementation pour remplir le formulaire avec un email invalide
    print('Scenario: I fill in the form with invalid email');
  }

  @And('I click on create account button')
  Future<void> iClickOnCreateAccountButton(dynamic tester) async {
    // Implementation pour cliquer sur le bouton de création de compte
    print('Scenario: I click on create account button');
  }

  @Then('I should be redirected to the select team page')
  Future<void> iShouldBeRedirectedToTheSelectTeamPage(dynamic tester) async {
    // Implementation pour être redirigé vers la page de sélection d'équipe
    print('Scenario: I should be redirected to the select team page');
  }

  @Then('I should see an error message')
  Future<void> iShouldSeeAnErrorMessage(dynamic tester) async {
    // Implementation pour voir un message d'erreur
    print('Scenario: I should see an error message');
  }
}

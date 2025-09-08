Feature: Create Account
  Testing account creation with background steps

  Background:
    Given I am on the splash screen without values
    And I redirected to the login page
    And I want to create an account
    And I should be redirected to the create account page

  Scenario: Création de compte réussie avec données valides
    When I fill in the form with valid data
    And I click on create account button
    Then I should be redirected to the select team page

  Scenario: Création de compte échouée avec email invalide
    When I fill in the form with invalid email
    And I click on create account button
    Then I should see an error message

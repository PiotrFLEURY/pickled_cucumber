Feature: Create Account
  Testing account creation with background steps

  Background:
    Given I am on the splash screen without values
    And I redirected to the login page
    And I want to create an account
    And I should be redirected to the create account page

  Scenario: Create account successfully with valid data
    When I fill in the form with valid data
    And I click on create account button
    Then I should be redirected to the select team page

  Scenario: Create account failed with invalid email
    When I fill in the form with invalid email
    And I click on create account button
    Then I should see an error message

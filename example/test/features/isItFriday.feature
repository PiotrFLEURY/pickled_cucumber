Feature: Is it Friday yet?
  Everybody wants to know when it's Friday

  Scenario: Sunday isn't Friday
    Given today is Sunday
    When I ask whether it's Friday yet
    Then I should be told "Nope"

  Scenario: Today is Friday
    Given today is Friday
    When I ask whether it's Friday yet
    Then I should be told "Yes"
  
  Scenario: Today is parameterized
    Given today is "Monday"
    When I ask whether it's Friday yet
    Then I should be told "Nope"

  Scenario: Friday is parameterized
    Given today is "Friday"
    When I ask whether it's Friday yet
    Then I should be told "Yes"

  Scenario: Friday is the fifth day
    Given today is "Friday"
    When I ask the number of the day
    Then it should be 5

  Scenario: Monday is the first day
    Given today is "Monday"
    When I ask the number of the day
    Then it should be 1
    
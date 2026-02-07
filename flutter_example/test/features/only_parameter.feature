Feature: Only parameters

    Feature with Scenarios containing only parametrized steps should generate code

    Scenario: Only parameters
        Given I have a parameter "param1"
        When I use the parameter "param1"
        Then I should see the parameter "param1" in the report
Feature: Jira
    Jira ticket can be linked to scenario

    @JIRA-1234 @JIRA-5678
    Scenario: Scenario with Jira ticket
        Given I have a scenario with Jira ticket
        When I link Jira ticket to the scenario
        Then I should see Jira ticket in the report
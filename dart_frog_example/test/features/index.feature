Feature: index

    Scenario: GET index route
        Given my app is running
        When I visit the index route
        Then I should see "Welcome to Dart Frog!"
        And receive a 200 status code
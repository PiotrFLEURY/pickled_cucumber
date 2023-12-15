Feature: Strings
    String concatentation operations

    Scenario: Concatenate two strings
        Given two strings "Hello" and "World"
        When I concatenate the two strings
        Then I get "HelloWorld"
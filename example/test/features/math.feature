Feature: Math
    Some basical math functions
    
    Scenario: Addition
        Given I have entered 50.0 into the calculator
        When I add 70.0
        Then the result should be 120.0 on the screen

    Scenario: Addition with decimals
        Given I have entered 3.0 into the calculator
        When I add 0.14
        Then the result should be 3.14 on the screen

    Scenario: Subtraction
        Given I have entered 50.0 into the calculator
        When I subtract 70.0
        Then the result should be -20.0 on the screen
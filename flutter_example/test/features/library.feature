Feature: A library file with multiple classes should generate pickled cucumber step methods

    Scenario: A library file with multiple classes should generate pickled cucumber step methods
        Given a library file with 2 classes and step definitions
        When I resolve the step methods from the library file
        Then I should get a list of step methods that includes the method from the first class

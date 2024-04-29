Feature: counter
    counter should increment

    Scenario: increment counter
      Given counter is 0
      When I increment counter
      Then counter should be 1

    Scenario: increment counter twice
      Given counter is 0
      When I increment counter twice
      Then counter should be 2

    Scenario: increment counter ten times
      Given counter is 0
      When I increment counter 10 times
      Then counter should be 10

    Scenario: increment counter ten times with comments
      Given counter is 0
      When I increment counter 10 times
      # And whatever
      Then counter should be 10
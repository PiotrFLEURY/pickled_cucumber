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
# Cucumber Dart

A simple Dart engine for Cucumber scenarios.

## Getting started

Add it to your `pubspec.yaml`:

```yaml
dependencies:
  cucumber_dart: 
    git: https://github.com/PiotrFLEURY/cucumber_dart.git
```

## Usage

Write your first feature file in any directory

```gherkin
# features/counter.feature

Feature: Counter

  Scenario: Increment counter
    Given a variable set to 1
    When I increment the variable by 1
    Then the variable should contain 2
```

Create your Dart step definitions file

```dart
// features/step_definitions/counter_steps.dart
class CounterStepDefs {

    int _counter;
    
    @Given("a variable set to {int}")
    void aVariableIsSetTo(int value) {
        _counter = value;
    }
    
    @When("I increment the variable by {int}")
    void iIncrementTheVariableBy(int value) {
        _counter += value;
    }

    @Then("the variable should contain {int}")
    void theVariableShouldContain(int value) {
        expect(_counter, value);
    }
}
```

Create your entry point in `test` directory

```dart
// test/cucumber_test.dart
import 'package:cucumber_dart/cucumber_dart.dart';
import 'package:counter/features/step_definitions/counter_steps.dart';

void main() {
    final stepDefsDartFile = CounterStepDefs();

    CucumberDart.runFeatures(
        "features/counter.feature",
        stepDefsDartFile,
    );
}
```

Run your tests

```bash
dart test test/cucumber_test.dart
```

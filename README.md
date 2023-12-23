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

### Dart usage

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

### Flutter usage

Cucumber Dart works with code generation for Flutter projects.

Please add `build_runner` dependency to your project

```bash
flutter pub add dev:build_runner
```

Write your first feature file in `test/features` directory

```gherkin
# test/features/counter.feature

Feature: counter
    counter should increment

    Scenario: increment counter
      Given counter is 0
      When I increment counter
      Then counter should be 1
```

Create your Dart step definitions file in `test/` directory

> ⚠️ IMPORTANT: only import annotations ⚠️

```dart
// test/counter_steps.dart

// IMPORTANT: ⚠️ only import annotations ⚠️
import 'package:cucumber_dart/src/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

@StepDefinition()
class CounterSteps {
  @Given('counter is {int}')
  Future<void> counterIs(WidgetTester tester, int counter) async {
    debugPrint('counter is $counter');
    await tester.pumpWidget(const MyApp());

    expect(find.text('$counter'), findsOneWidget);
  }

  @When('I increment counter')
  Future<void> iIncrementCounter(
    WidgetTester tester,
  ) async {
    debugPrint('I increment counter');

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
  }

  @Then('counter should be {int}')
  Future<void> counterShouldBe(WidgetTester tester, int counter) async {
    debugPrint('counter should be $counter');

    expect(find.text('$counter'), findsOneWidget);
  }
}

```

Run `build_runner` to generate the step definitions file

```bash
flutter pub run build_runner build
```

Create your entry point in `test` directory

```dart
// test/cucumber_test.dart
import 'counter_steps.g.dart';

main() => runFeatures();
```

Run your tests as Widget tests

```bash
flutter test test/cucumber_test.dart
# or
flutter test
```

Run your tests as Integration tests

Create your entry point in `integration_test` directory

```dart
// integration_test/app_test.dart
import 'package:integration_test/integration_test.dart';

import '../test/counter_step_definitions.g.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  runFeatures();
}
```

Run your tests

```bash
flutter test integration_test/app_test.dart
```

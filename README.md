# 🥒 Cucumber Dart 🎯

A simple Dart engine for Cucumber scenarios.

Works with **[🎯 Dart](#dart-usage)**, **[🐸 Dart Frog](#dart-frog-usage)** and **[🐦 Flutter](#flutter-usage)** projects.

> **ℹ️ Note:**
>
> This is non official package, not affiliated with the Cucumber nor the Dart project.
>
> The goal of this project is to provide a simple way to run Cucumber scenarios in Dart and Flutter projects.
>
> This project does not aim to be a full Cucumber implementation. It only supports the most common features of Cucumber.

## Table of contents

- [🥒 Cucumber Dart 🎯](#-cucumber-dart-)
  - [Table of contents](#table-of-contents)
  - [Getting started](#getting-started)
    - [🎯 Dart usage](#dart-usage)
    - [🐸 Dart Frog usage](#dart-frog-usage)
    - [🐦 Flutter usage](#flutter-usage)
  - [Links](#links)

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

### Dart Frog usage

Cucumber Dart works the exact same way as Dart with Dart Frog.

Write your first feature file in any directory

```gherkin
# test/features/index.feature
Feature: index

    Scenario: GET index route
        Given my app is running
        When I visit the index route
        Then I should see "Welcome to Dart Frog!"
        And receive a 200 status code
```

Create your Dart Frog step definitions file

```dart
// test/step_definitions.dart
import 'package:cucumber_dart/cucumber_dart.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:test/test.dart';
import '../routes/index.dart' as route;

class MockRequestContext extends mocktail.Mock implements RequestContext {}

class DartFrogStepDefinition {
  late MockRequestContext context;
  Response? response;

  @Given('my app is running')
  void myAppIsRunning() {
    context = MockRequestContext();
  }

  @When('I visit the index route')
  void iVisitTheIndexRoute() {
    response = route.onRequest(context);
  }

  @Then('I should see {string}')
  Future<void> iShouldSee(String string) async {
    expect(response!.body(), completion(equals(string)));
  }

  @And('receive a {int} status code')
  void receiveStatusCode(int statusCode) {
    expect(response!.statusCode, equals(statusCode));
  }
}

```

Create your entry point in `test` directory

```dart
// test/cucumber_test.dart
import 'package:cucumber_dart/cucumber_dart.dart';

import 'step_definitions.dart';

void main() {
  CucumberDart().runFeatures(
    'test/features/',
    DartFrogStepDefinition(),
  );
}

```

### Flutter usage

With Cucumber Dart, you can [Flutter integration tests](https://docs.flutter.dev/cookbook/testing/integration/introduction) and [Widget tests](https://docs.flutter.dev/cookbook/testing/widget/introduction) using Cucumber scenarios.

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

## Links

- [Learn Cucumber](https://cucumber.io/docs/guides/overview/)
- [Learn Dart](https://dart.dev/guides)
- [Learn Dart Frog](https://dartfrog.vgv.dev/)
- [Learn Flutter](https://flutter.dev/docs)

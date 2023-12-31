import 'package:pickled_cucumber/src/annotations.dart';
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

  @When('I increment counter twice')
  Future<void> iIncrementCounterTwice(
    WidgetTester tester,
  ) async {
    debugPrint('I increment counter twice');

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
  }

  @When('I increment counter {int} times')
  Future<void> iIncrementCounterTimes(
    WidgetTester tester,
    int times,
  ) async {
    debugPrint('I increment counter twice');

    for (var i = 0; i < times; i++) {
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
    }
  }

  @Then('counter should be {int}')
  Future<void> counterShouldBe(WidgetTester tester, int counter) async {
    debugPrint('counter should be $counter');

    expect(find.text('$counter'), findsOneWidget);
  }
}

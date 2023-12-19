import 'package:cucumber_dart/cucumber_dart.dart';
import 'package:test/test.dart';

class ExampleStepDefinitions {
  late String today;
  late String answer;
  late int dayNumberAnswer;

  late double calculatorInput;

  late List<String> strings;

  final days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @Given("today is Sunday")
  void todayIsSunday() {
    today = "Sunday";
  }

  @Given("today is Friday")
  void todayIsFriday() {
    today = "Friday";
  }

  @Given("today is {string}")
  void todayIs(String day) {
    today = day;
  }

  @When("I ask whether it's Friday yet")
  void iAskWhetherItsFridayYet() {
    if (today == "Friday") {
      answer = "Yes";
    } else {
      answer = "Nope";
    }
  }

  @When("I ask the number of the day")
  void whenIAskTheNumberOfTheDay() {
    final dayNumber = days.indexOf(today) + 1;
    dayNumberAnswer = dayNumber;
  }

  @Then("I should be told {string}")
  void iShouldBeTold(String string) {
    expect(answer, string);
  }

  @Then("it should be {int}")
  void thenItShouldBe(int dayNumber) {
    expect(dayNumberAnswer, dayNumber);
  }

  /// ---- CALCULATOR

  @Given("I have entered {float} into the calculator")
  void iHaveEnteredIntIntoTheCalculator(double number) {
    calculatorInput = number;
  }

  @When("I add {float}")
  void iAdd(double number) {
    calculatorInput += number;
  }

  @When("I subtract {float}")
  void iSubtract(double number) {
    calculatorInput -= number;
  }

  @Then("the result should be {float} on the screen")
  void theResultShouldBe(double result) {
    expect(calculatorInput, result);
  }

  /// ---- STRINGS

  @Given("two strings {string} and {string}")
  void iHaveTwoStringsAnd(String string1, String string2) {
    strings = [string1, string2];
  }

  @When("I concatenate the two strings")
  void iConcatenateTheTwoStrings() {
    strings = [strings.join("")];
  }

  @Then("I get {string}")
  void iGet(String string) {
    expect(strings.first, string);
  }

  /// ---- YES BUT

  @Given("the weather is cold")
  void theWeatherIsCold() {}

  @Given("the weather is hot")
  void theWeatherIsHot() {}

  @When("I wear a jacket")
  void iWearAJacket() {}

  @Then("I should not be cold")
  void iShouldNotBeCold() {}

  @Then("I should be too hot")
  void iShouldBeTooHot() {}

  @But("I should be stylish")
  void iShouldBeStylish() {}

  @But("I will not get sunburned")
  void iWillNotGetSunburned() {}
}

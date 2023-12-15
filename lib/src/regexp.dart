///
/// Dart RegExp used to parse Gherkin files
///
class CucumberRegex {
  /// Feature RegExp
  /// Example:
  /// ```gherkin
  /// Feature: My feature
  /// ```
  static final feature = RegExp(r'Feature:(.*)');

  /// Scenario RegExp
  /// Example:
  /// ```gherkin
  /// Scenario: My scenario
  /// ```
  static final scenario = RegExp(r'Scenario:(.*)');

  /// Given RegExp
  /// Example:
  /// ```gherkin
  /// Given I have a step
  /// ```
  static final givenStep = RegExp(r'Given(.*)');

  /// When RegExp
  /// Example:
  /// ```gherkin
  /// When I have a step
  /// ```
  static final whenStep = RegExp(r'When(.*)');

  /// Then RegExp
  /// Example:
  /// ```gherkin
  /// Then I have a step
  /// ```
  static final thenStep = RegExp(r'Then(.*)');

  /// And RegExp
  /// Example:
  /// ```gherkin
  /// And I have a step
  /// ```
  static final andStep = RegExp(r'And(.*)');

  /// But RegExp
  /// Example:
  /// ```gherkin
  /// But I have a step
  /// ```
  static final butStep = RegExp(r'But(.*)');

  /// String argument RegExp
  /// Example:
  /// ```gherkin
  /// Given I have "42" cukes
  /// ```
  static final string = RegExp(r'\"([\w.-]*)\"');

  /// Int argument RegExp
  /// Example:
  /// ```gherkin
  /// Given I have 42 cukes
  /// ```
  static final int = RegExp(r'\s([+-]*\d+)');

  /// Float argument RegExp
  /// Example:
  /// ```gherkin
  /// Given I have 42.42 cukes
  /// ```
  static final float = RegExp(r'\s([+-]*\d+\.\d+)');

  /// Every possible step RegExp
  static final possibleSteps = [
    CucumberRegex.givenStep,
    CucumberRegex.whenStep,
    CucumberRegex.thenStep,
    CucumberRegex.andStep,
    CucumberRegex.butStep,
  ];
}


class CucumberRegex {
  static final feature = RegExp(r'Feature:(.*)');
  static final scenario = RegExp(r'Scenario:(.*)');
  static final givenStep = RegExp(r'Given(.*)');
  static final whenStep = RegExp(r'When(.*)');
  static final thenStep = RegExp(r'Then(.*)');
  static final andStep = RegExp(r'And(.*)');
  static final butStep = RegExp(r'But(.*)');

  static final string = RegExp(r'\"([\w.-]*)\"');
  static final int = RegExp(r'\s([+-]*\d+)');
  static final float = RegExp(r'\s([+-]*\d+\.\d+)');
}

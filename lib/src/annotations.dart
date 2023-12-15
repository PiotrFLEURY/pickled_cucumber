/// Base class for all Gherkin annotations.
abstract class GherkinAnnotation {

  /// The value of the annotation.
  /// eg. `@Given('I have a step')` => `I have a step`
  final String value;

  /// Creates a new instance of [GherkinAnnotation].
  const GherkinAnnotation(this.value);
}

/// Given annotation.
/// Used to mark a method as a Given step.
class Given extends GherkinAnnotation {
  /// Creates a new instance of [Given].
  const Given(String value) : super(value);
}

/// When annotation.
/// Used to mark a method as a When step.
class When extends GherkinAnnotation {
  /// Creates a new instance of [When].
  const When(String value) : super(value);
}

/// Then annotation.
/// Used to mark a method as a Then step.
class Then extends GherkinAnnotation {
  /// Creates a new instance of [Then].
  const Then(String value) : super(value);
}

/// And annotation.
/// Used to mark a method as a And step.
class And extends GherkinAnnotation {
  /// Creates a new instance of [And].
  const And(String value) : super(value);
}

/// But annotation.
/// Used to mark a method as a But step.
class But extends GherkinAnnotation {
  /// Creates a new instance of [But].
  const But(String value) : super(value);
}
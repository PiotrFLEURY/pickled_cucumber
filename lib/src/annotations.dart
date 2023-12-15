
abstract class _GherkinAnnotation {
  final String value;
  const _GherkinAnnotation(this.value);
}

class Given extends _GherkinAnnotation {
  const Given(String value) : super(value);
}

class When extends _GherkinAnnotation {
  const When(String value) : super(value);
}

class Then extends _GherkinAnnotation {
  const Then(String value) : super(value);
}

class And extends _GherkinAnnotation {
  const And(String value) : super(value);
}

class But extends _GherkinAnnotation {
  const But(String value) : super(value);
}
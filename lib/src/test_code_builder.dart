import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:cucumber_dart/cucumber_dart.dart';
import 'package:cucumber_dart/src/model.dart';
import 'package:dart_style/dart_style.dart';
import 'package:file/local.dart';
import 'package:source_gen/source_gen.dart';

class TestCodeBuilder extends GeneratorForAnnotation<StepDefinition> {
  String _buildCode(
    List<Feature> features,
    List<StepMethod> stepMethods,
    String stepDefsUri,
    String stepDefsClassName,
    CucumberDart cucumberDart,
  ) {
    final library = Library(
      (b) => b
        ..directives.addAll([
          Directive.import(stepDefsUri),
          Directive.import('package:flutter_test/flutter_test.dart'),
        ])
        ..body.addAll([
          Method(
            (m) => m
              ..name = 'runFeatures'
              ..body = Block.of([
                refer(
                  'final steps = $stepDefsClassName()',
                ).statement,
                for (final feature in features)
                  refer('group').newInstance([
                    literal(feature.name),
                    Method((group) => group
                      ..body = Block.of(
                        feature.scenarios.map(
                          (scenario) => refer('testWidgets').newInstance(
                            [
                              literal(scenario.name),
                              Method(
                                (test) => test
                                  ..modifier = MethodModifier.async
                                  ..requiredParameters.addAll([
                                    Parameter(
                                      (p) => p
                                        ..name = 'widgetTester'
                                        ..type = refer('WidgetTester'),
                                    ),
                                  ])
                                  ..body = Block.of(
                                    scenario.steps.map(
                                      (step) {
                                        print('building step $step');
                                        StepMethod stepMethod =
                                            stepMethods.firstWhere(
                                          (method) => methodApplyTo(
                                            method,
                                            step,
                                            cucumberDart,
                                          ),
                                        );
                                        return refer(
                                                'await steps.${stepMethod.methodName}')
                                            .call(
                                          [
                                            refer('widgetTester'),
                                            ...orderedArguments(
                                              cucumberDart,
                                              step,
                                            )
                                          ],
                                        ).statement;
                                      },
                                    ).toList(),
                                  ),
                              ).closure,
                            ],
                          ).statement,
                        ),
                      )).closure,
                  ]).statement,
              ]),
          ),
        ]),
    );
    return DartFormatter().format('${library.accept(
      DartEmitter(
        orderDirectives: true,
      ),
    )}');
  }

  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final classElement = element as ClassElement;
    final lib = LibraryReader(await buildStep.inputLibrary);

    final cucumberDart = CucumberDart();

    final features = cucumberDart.parseFeatures(
      LocalFileSystem(),
      'test/features/',
    );

    final stepMethods = <StepMethod>[];
    lib.allElements
        .whereType<ClassElement>()
        .first // FIXME: manage all classes
        .methods
        .forEach((methodElement) {
      print('method ${methodElement.displayName}');
      for (var meta in methodElement.metadata) {
        print('metadata ${meta.computeConstantValue()}');
        // get the value of the annotation
        final value = meta.computeConstantValue();
        print('value $value');
        final superValue = value?.getField('(super)');
        if (superValue?.type?.getDisplayString(withNullability: false) ==
            'GherkinAnnotation') {
          print('found Gherkin annotation');
          final annotationValue =
              superValue?.getField('value')?.toStringValue();
          print('annotationValue $annotationValue');
          if (annotationValue != null) {
            final annotationName = value?.type?.getDisplayString(
              withNullability: false,
            );
            stepMethods.add(toStepMethod(
              features,
              "$annotationName $annotationValue",
              methodElement,
              cucumberDart,
            ));
          }
        }
      }
    });

    return _buildCode(
      features,
      stepMethods,
      classElement.librarySource.uri.pathSegments.last,
      element.displayName,
      cucumberDart,
    );
  }

  bool methodApplyTo(
    StepMethod method,
    String step,
    CucumberDart cucumberDart,
  ) {
    final sanitizedStep = cucumberDart.sanytizeStep(step);
    bool apply = method.stepName == sanitizedStep;
    if (!apply) {
      print('method ${method.stepName} does not apply to $sanitizedStep');
    }
    return apply;
  }

  List<Expression> orderedArguments(
    CucumberDart cucumberDart,
    String stepName,
  ) {
    return cucumberDart
        .extractOrderedArguments(
      cucumberDart.sanytizeStep(stepName),
      stepName,
    )
        .map((arg) {
      switch (arg.runtimeType) {
        case const (String):
          return literal(arg);
        case const (double):
        case const (int):
          return literalNum(arg);
        default:
          throw Exception('Unknown type ${arg.runtimeType}');
      }
    }).toList();
  }

  StepMethod toStepMethod(
    List<Feature> features,
    String stepName,
    MethodElement methodElement,
    CucumberDart cucumberDart,
  ) {
    final methodName = methodElement.displayName;

    return StepMethod(
      stepName,
      methodName,
    );
  }
}

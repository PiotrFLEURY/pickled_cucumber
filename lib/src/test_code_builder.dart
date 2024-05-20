import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:pickled_cucumber/pickled_cucumber.dart';
import 'package:pickled_cucumber/src/model.dart';
import 'package:dart_style/dart_style.dart';
import 'package:file/local.dart';
import 'package:source_gen/source_gen.dart';

///
/// Generates the test code for the step definitions
///
class TestCodeBuilder extends GeneratorForAnnotation<StepDefinition> {
  ///
  /// Builds the Flutter test code for the step definitions
  /// and the corresponding features
  ///
  String buildCode(
    List<Feature> features,
    List<StepMethod> stepMethods,
    String stepDefsUri,
    String stepDefsClassName,
    PickledCucumber pickledCucumber,
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
                                        StepMethod stepMethod =
                                            stepMethods.firstWhere(
                                          (method) => methodApplyTo(
                                            method,
                                            step,
                                            pickledCucumber,
                                          ),
                                          orElse: () => throw Exception(
                                            'Step not found $step',
                                          ),
                                        );
                                        return refer(
                                                'await steps.${stepMethod.methodName}')
                                            .call(
                                          [
                                            refer('widgetTester'),
                                            ...orderedArguments(
                                              pickledCucumber,
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

    final pickledCucumber = PickledCucumber();

    final features = pickledCucumber.parseFeatures(
      LocalFileSystem(),
      'test/features/',
    );

    final stepMethods = <StepMethod>[];
    lib.allElements
        .whereType<ClassElement>()
        .first // should manage all classes
        .methods
        .forEach((methodElement) {
      for (var meta in methodElement.metadata) {
        // get the value of the annotation
        final value = meta.computeConstantValue();
        final superValue = value?.getField('(super)');
        if (superValue?.type?.getDisplayString() == 'GherkinAnnotation') {
          final annotationValue =
              superValue?.getField('value')?.toStringValue();
          if (annotationValue != null) {
            final annotationName = value?.type?.getDisplayString();
            stepMethods.add(toStepMethod(
              features,
              "$annotationName $annotationValue",
              methodElement,
              pickledCucumber,
            ));
          }
        }
      }
    });

    return buildCode(
      featuresInSteps(features, stepMethods),
      stepMethods,
      classElement.librarySource.uri.pathSegments.last,
      element.displayName,
      pickledCucumber,
    );
  }

  ///
  /// Returns the features that have steps that are in the list of step methods
  /// Other features are ignored and supposed to be defined in another step file
  ///
  List<Feature> featuresInSteps(
      List<Feature> features, List<StepMethod> stepMethods) {
    return features.where((feature) {
      return feature.scenarios.any((scenario) {
        return scenario.steps.any((step) {
          return stepMethods.any((stepMethod) {
            return stepMethod.stepName == step;
          });
        });
      });
    }).toList();
  }

  ///
  /// Determines whether the method applies to the step or not
  ///
  bool methodApplyTo(
    StepMethod method,
    String step,
    PickledCucumber pickledCucumber,
  ) {
    final sanitizedStep = pickledCucumber.sanytizeStep(step);
    return method.stepName == sanitizedStep;
  }

  List<Expression> orderedArguments(
    PickledCucumber pickledCucumber,
    String stepName,
  ) {
    return pickledCucumber
        .extractOrderedArguments(
      pickledCucumber.sanytizeStep(stepName),
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

  ///
  /// Converts a method element to a step method
  ///
  StepMethod toStepMethod(
    List<Feature> features,
    String stepName,
    MethodElement methodElement,
    PickledCucumber pickledCucumber,
  ) {
    final methodName = methodElement.displayName;

    return StepMethod(
      stepName,
      methodName,
    );
  }
}

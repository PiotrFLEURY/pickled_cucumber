import 'package:dart_style/dart_style.dart';
import 'package:pickled_cucumber/pickled_cucumber.dart';
import 'package:pickled_cucumber/src/model.dart';
import 'package:pickled_cucumber/src/test_code_builder.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

void main() {
  final pickledCucumber = PickledCucumber();
  final codeBuilder = TestCodeBuilder();

  group('buildCode', () {
    test('should build code for a single feature', () {
      // Given
      final features = [
        Feature(
          'My feature',
          [
            Scenario(
              'My scenario',
              [
                'Given I have a step',
                'When I do womething',
                'Then I should get a result',
                'And being able to use "string value" and 42 numbers',
              ],
            ),
          ],
        ),
      ];
      final stepMethods = [
        StepMethod('Given I have a step', "iHaveAStep"),
        StepMethod('When I do womething', "iDoSomething"),
        StepMethod('Then I should get a result', "iShouldGetAResult"),
        StepMethod('And being able to use {string} and {int} numbers',
            "beingAbleToUseStringAndInt"),
      ];
      final stepDefsUri = 'package:my_app/step_defs.dart';
      final stepDefsClassName = 'StepDefs';

      // When
      final code = codeBuilder.buildCode(
        features,
        stepMethods,
        stepDefsUri,
        stepDefsClassName,
        pickledCucumber,
      );

      // Then
      final expectedCode = '''
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/step_defs.dart';

runFeatures() {
  final steps = StepDefs();
  group(
    'My feature',
    () {
      testWidgets(
        'My scenario',
        (WidgetTester widgetTester) async {
          await steps.iHaveAStep(widgetTester);
          await steps.iDoSomething(widgetTester);
          await steps.iShouldGetAResult(widgetTester);
          await steps.beingAbleToUseStringAndInt(
            widgetTester,
            'string value',
            42,
          );
        },
      );
    },
  );
}


''';
      expect(
        code,
        DartFormatter(languageVersion: Version(3, 8, 0)).format(expectedCode),
      );
    });

    test('should throw explicit error on step not found', () {
      // Given
      final features = [
        Feature(
          'My feature',
          [
            Scenario(
              'My scenario',
              [
                'Given I have a step',
                'When I do womething',
                'Then I should get a result',
              ],
            ),
          ],
        ),
      ];
      final stepMethods = [
        StepMethod('Given I have a step', "iHaveAStep"),
        StepMethod('When I do womething', "iDoSomething"),
        // Last step not defined
      ];
      final stepDefsUri = 'package:my_app/step_defs.dart';
      final stepDefsClassName = 'StepDefs';

      // When
      codeBuilderCallback() => codeBuilder.buildCode(
            features,
            stepMethods,
            stepDefsUri,
            stepDefsClassName,
            pickledCucumber,
          );

      // Then
      expect(
        codeBuilderCallback,
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'toString',
            'Exception: Step not found Then I should get a result',
          ),
        ),
      );
    });

    test('should build code for a feature with background', () {
      // Given
      final features = [
        Feature(
          'My feature with background',
          [
            Scenario(
              'My first scenario',
              [
                'When I perform an action',
                'Then I should see a result',
              ],
            ),
            Scenario(
              'My second scenario',
              [
                'When I perform another action',
                'Then I should see another result',
              ],
            ),
          ],
          backgroundSteps: [
            'Given I am on the splash screen',
            'And I redirected to the login page',
          ],
        ),
      ];
      final stepMethods = [
        StepMethod('Given I am on the splash screen', "iAmOnTheSplashScreen"),
        StepMethod(
            'And I redirected to the login page', "iRedirectedToTheLoginPage"),
        StepMethod('When I perform an action', "iPerformAnAction"),
        StepMethod('Then I should see a result', "iShouldSeeAResult"),
        StepMethod('When I perform another action', "iPerformAnotherAction"),
        StepMethod(
            'Then I should see another result', "iShouldSeeAnotherResult"),
      ];
      final stepDefsUri = 'package:my_app/step_defs.dart';
      final stepDefsClassName = 'StepDefs';

      // When
      final code = codeBuilder.buildCode(
        features,
        stepMethods,
        stepDefsUri,
        stepDefsClassName,
        pickledCucumber,
      );

      // Then
      final expectedCode = '''
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/step_defs.dart';

runFeatures() {
  final steps = StepDefs();
  group(
    'My feature with background',
    () {
      testWidgets(
        'My first scenario',
        (WidgetTester widgetTester) async {
          await steps.iAmOnTheSplashScreen(widgetTester);
          await steps.iRedirectedToTheLoginPage(widgetTester);
          await steps.iPerformAnAction(widgetTester);
          await steps.iShouldSeeAResult(widgetTester);
        },
      );
      testWidgets(
        'My second scenario',
        (WidgetTester widgetTester) async {
          await steps.iAmOnTheSplashScreen(widgetTester);
          await steps.iRedirectedToTheLoginPage(widgetTester);
          await steps.iPerformAnotherAction(widgetTester);
          await steps.iShouldSeeAnotherResult(widgetTester);
        },
      );
    },
  );
}


''';
      expect(
        code,
        DartFormatter(languageVersion: Version(3, 8, 0)).format(expectedCode),
      );
    });
  });
  group('methodApplyTo', () {
    test('should return true when method stepName matches sanitizedStep', () {
      // Given
      final method = StepMethod('Given my name is {string}', "myNameIs");
      final step = 'Given my name is "Piotr"';

      // When
      final result = codeBuilder.methodApplyTo(method, step, pickledCucumber);

      // Then
      expect(result, true);
    });
    test(
        'should return false when method stepName does not match sanitizedStep',
        () {
      // Given
      final method = StepMethod('Given my name is {string}', "myNameIs");
      final step = 'Given my name is not "Piotr"';

      // When
      final result = codeBuilder.methodApplyTo(method, step, pickledCucumber);

      // Then
      expect(result, false);
    });
  });

  group('featuresInSteps', () {
    test('should filter features not defined in step methods', () {
      // Given
      final features = [
        Feature(
          'My feature',
          [
            Scenario(
              'My scenario',
              [
                'Given I have a step',
                'When I do womething',
                'Then I should get a result',
              ],
            ),
          ],
        ),
        Feature(
          'My other feature',
          [
            Scenario(
              'My other scenario',
              [
                'Given I have another step',
                'When I do something else',
                'Then I should get another result',
              ],
            ),
          ],
        ),
      ];
      final stepMethods = [
        StepMethod('Given I have a step', "iHaveAStep"),
        StepMethod('When I do womething', "iDoSomething"),
        StepMethod('Then I should get a result', "iShouldGetAResult"),
      ];

      // When
      final result = codeBuilder.featuresInSteps(features, stepMethods);

      // Then
      final expectedFeature = Feature(
        'My feature',
        [
          Scenario(
            'My scenario',
            [
              'Given I have a step',
              'When I do womething',
              'Then I should get a result',
            ],
          ),
        ],
      );
      expect(result.length, 1);
      expect(result[0].name, expectedFeature.name);
      expect(result[0].scenarios.length, expectedFeature.scenarios.length);
      for (var i = 0; i < result[0].scenarios.length; i++) {
        expect(result[0].scenarios[i].name, expectedFeature.scenarios[i].name);
        expect(result[0].scenarios[i].steps.length,
            expectedFeature.scenarios[i].steps.length);
        for (var j = 0; j < result[0].scenarios[i].steps.length; j++) {
          expect(result[0].scenarios[i].steps[j],
              expectedFeature.scenarios[i].steps[j]);
        }
      }
    });
  });
}

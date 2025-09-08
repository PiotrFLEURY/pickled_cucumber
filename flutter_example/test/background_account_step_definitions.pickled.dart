// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'background_account_step_definitions.dart';

runFeatures() {
  final steps = BackgroundAccountStepDefinitions();
  group('Create Account', () {
    testWidgets('Création de compte réussie avec données valides', (
      WidgetTester widgetTester,
    ) async {
      await steps.iAmOnTheSplashScreenWithoutValues(widgetTester);
      await steps.iRedirectedToTheLoginPage(widgetTester);
      await steps.iWantToCreateAnAccount(widgetTester);
      await steps.iShouldBeRedirectedToTheCreateAccountPage(widgetTester);
      await steps.iFillInTheFormWithValidData(widgetTester);
      await steps.iClickOnCreateAccountButton(widgetTester);
      await steps.iShouldBeRedirectedToTheSelectTeamPage(widgetTester);
    });
    testWidgets('Création de compte échouée avec email invalide', (
      WidgetTester widgetTester,
    ) async {
      await steps.iAmOnTheSplashScreenWithoutValues(widgetTester);
      await steps.iRedirectedToTheLoginPage(widgetTester);
      await steps.iWantToCreateAnAccount(widgetTester);
      await steps.iShouldBeRedirectedToTheCreateAccountPage(widgetTester);
      await steps.iFillInTheFormWithInvalidEmail(widgetTester);
      await steps.iClickOnCreateAccountButton(widgetTester);
      await steps.iShouldSeeAnErrorMessage(widgetTester);
    });
  });
}

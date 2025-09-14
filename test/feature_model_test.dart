import 'package:pickled_cucumber/src/model.dart';
import 'package:test/test.dart';

void main() {
  group('From feature', () {
    test('simple', () {
      // Given
      final featureFileContent = '''
        Feature: My feature
        
          Scenario: My scenario
            Given I have a step
            When I have another step
            Then I have a third step
      ''';
      final featureLines = featureFileContent.split('\n');

      // When
      final feature = Feature.fromFeature(featureLines);

      // Then
      expect(feature.name, equals('My feature'));
      expect(feature.scenarios.length, equals(1));
      expect(feature.scenarios.first.name, equals('My scenario'));
      expect(feature.scenarios.first.steps.length, equals(3));
      expect(feature.scenarios.first.steps[0], equals('Given I have a step'));
      expect(
          feature.scenarios.first.steps[1], equals('When I have another step'));
      expect(
          feature.scenarios.first.steps[2], equals('Then I have a third step'));
    });
    test('with and & but', () {
      // Given
      final featureFileContent = '''
        Feature: My feature
        
          Scenario: My scenario
            Given I have a step
            And I have another step
            When I have a third step
            Then I have a fourth step
            But I have a fifth step
      ''';
      final featureLines = featureFileContent.split('\n');

      // When
      final feature = Feature.fromFeature(featureLines);

      // Then
      expect(feature.name, equals('My feature'));
      expect(feature.scenarios.length, equals(1));
      expect(feature.scenarios.first.name, equals('My scenario'));
      expect(feature.scenarios.first.steps.length, equals(5));
      expect(feature.scenarios.first.steps[0], equals('Given I have a step'));
      expect(
          feature.scenarios.first.steps[1], equals('And I have another step'));
      expect(
          feature.scenarios.first.steps[2], equals('When I have a third step'));
      expect(feature.scenarios.first.steps[3],
          equals('Then I have a fourth step'));
      expect(
          feature.scenarios.first.steps[4], equals('But I have a fifth step'));
    });
    test('multiple scenarios', () {
      // Given
      final featureFileContent = '''
        Feature: My feature
        
          Scenario: My scenario
            Given I have a step
            When I have another step
            Then I have a third step
          
          Scenario: My second scenario
            Given I have a step
            When I have another step
            Then I have a third step
      ''';
      final featureLines = featureFileContent.split('\n');

      // When
      final feature = Feature.fromFeature(featureLines);

      // Then
      expect(feature.name, equals('My feature'));
      expect(feature.scenarios.length, equals(2));
      expect(feature.scenarios.first.name, equals('My scenario'));
      expect(feature.scenarios.first.steps.length, equals(3));
      expect(feature.scenarios.first.steps[0], equals('Given I have a step'));
      expect(
          feature.scenarios.first.steps[1], equals('When I have another step'));
      expect(
          feature.scenarios.first.steps[2], equals('Then I have a third step'));
      expect(feature.scenarios[1].name, equals('My second scenario'));
      expect(feature.scenarios[1].steps.length, equals(3));
      expect(feature.scenarios[1].steps[0], equals('Given I have a step'));
      expect(feature.scenarios[1].steps[1], equals('When I have another step'));
      expect(feature.scenarios[1].steps[2], equals('Then I have a third step'));
    });
    test('multiple scenarios with Jira tags', () {
      // Given
      final featureFileContent = '''
        Feature: My feature
        
          @JIRA-123 @JIRA-124
          Scenario: My scenario
            Given I have a step
            When I have another step
            Then I have a third step
          
          @JIRA-125 @JIRA-126
          Scenario: My second scenario
            Given I have a step
            When I have another step
            Then I have a third step
      ''';
      final featureLines = featureFileContent.split('\n');

      // When
      final feature = Feature.fromFeature(featureLines);

      // Then
      expect(feature.name, equals('My feature'));
      expect(feature.scenarios.length, equals(2));
      expect(feature.scenarios.first.name, equals('My scenario'));
      expect(feature.scenarios.first.steps.length, equals(3));
      expect(feature.scenarios.first.steps[0], equals('Given I have a step'));
      expect(
          feature.scenarios.first.steps[1], equals('When I have another step'));
      expect(
          feature.scenarios.first.steps[2], equals('Then I have a third step'));
      expect(feature.scenarios[1].name, equals('My second scenario'));
      expect(feature.scenarios[1].steps.length, equals(3));
      expect(feature.scenarios[1].steps[0], equals('Given I have a step'));
      expect(feature.scenarios[1].steps[1], equals('When I have another step'));
      expect(feature.scenarios[1].steps[2], equals('Then I have a third step'));
    });
    test('multiple scenarios with commented steps', () {
      // Given
      final featureFileContent = '''
        Feature: My feature
        
          Scenario: My scenario
            Given I have a step
            When I have another step
            Then I have a third step
          
          Scenario: My second scenario
            Given I have a step
            When I have another step
            # And Whatever
            Then I have a third step
      ''';
      final featureLines = featureFileContent.split('\n');

      // When
      final feature = Feature.fromFeature(featureLines);

      // Then
      expect(feature.name, equals('My feature'));
      expect(feature.scenarios.length, equals(2));
      expect(feature.scenarios.first.name, equals('My scenario'));
      expect(feature.scenarios.first.steps.length, equals(3));
      expect(feature.scenarios.first.steps[0], equals('Given I have a step'));
      expect(
          feature.scenarios.first.steps[1], equals('When I have another step'));
      expect(
          feature.scenarios.first.steps[2], equals('Then I have a third step'));
      expect(feature.scenarios[1].name, equals('My second scenario'));
      expect(feature.scenarios[1].steps.length, equals(3));
      expect(feature.scenarios[1].steps[0], equals('Given I have a step'));
      expect(feature.scenarios[1].steps[1], equals('When I have another step'));
      expect(feature.scenarios[1].steps[2], equals('Then I have a third step'));
    });
    test('with background', () {
      // Given
      final featureFileContent = '''
        Feature: My feature with background
        
          Background:
            Given I am on the splash screen
            And I redirected to the login page
        
          Scenario: My first scenario
            When I perform an action
            Then I should see a result
            
          Scenario: My second scenario
            When I perform another action
            Then I should see another result
      ''';
      final featureLines = featureFileContent.split('\n');

      // When
      final feature = Feature.fromFeature(featureLines);

      // Then
      expect(feature.name, equals('My feature with background'));
      expect(feature.backgroundSteps.length, equals(2));
      expect(feature.backgroundSteps[0],
          equals('Given I am on the splash screen'));
      expect(feature.backgroundSteps[1],
          equals('And I redirected to the login page'));
      expect(feature.scenarios.length, equals(2));
      expect(feature.scenarios.first.name, equals('My first scenario'));
      expect(feature.scenarios.first.steps.length, equals(2));
      expect(
          feature.scenarios.first.steps[0], equals('When I perform an action'));
      expect(feature.scenarios.first.steps[1],
          equals('Then I should see a result'));
      expect(feature.scenarios[1].name, equals('My second scenario'));
      expect(feature.scenarios[1].steps.length, equals(2));
      expect(feature.scenarios[1].steps[0],
          equals('When I perform another action'));
      expect(feature.scenarios[1].steps[1],
          equals('Then I should see another result'));
    });
  });
}

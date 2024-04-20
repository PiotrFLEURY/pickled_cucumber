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
  });
}

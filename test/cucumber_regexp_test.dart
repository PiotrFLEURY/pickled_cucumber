import 'package:cucumber_dart/src/regexp.dart';
import 'package:test/test.dart';

void main() {
  group('CucumberRegex', () {
    test('feature', () {
      // Given
      final input = 'Feature: My feature';

      // When
      final match = CucumberRegex.feature.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals(' My feature'));
    });

    test('scenario', () {
      // Given
      final input = 'Scenario: My scenario';

      // When
      final match = CucumberRegex.scenario.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals(' My scenario'));
    });

    test('givenStep', () {
      // Given
      final input = 'Given I have a step';

      // When
      final match = CucumberRegex.givenStep.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals(' I have a step'));
    });

    test('whenStep', () {
      // Given
      final input = 'When I have a step';

      // When
      final match = CucumberRegex.whenStep.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals(' I have a step'));
    });

    test('thenStep', () {
      // Given
      final input = 'Then I have a step';

      // When
      final match = CucumberRegex.thenStep.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals(' I have a step'));
    });

    test('andStep', () {
      // Given
      final input = 'And I have a step';

      // When
      final match = CucumberRegex.andStep.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals(' I have a step'));
    });

    test('butStep', () {
      // Given
      final input = 'But I have a step';

      // When
      final match = CucumberRegex.butStep.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals(' I have a step'));
    });

    test('string', () {
      // Given
      final input = 'Given I have "42" cukes';

      // When
      final match = CucumberRegex.string.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals('42'));
    });

    test('int', () {
      // Given
      final input = 'Given I have 42 cukes';

      // When
      final match = CucumberRegex.int.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals('42'));
    });

    test('float', () {
      // Given
      final input = 'Given I have 42.42 cukes';

      // When
      final match = CucumberRegex.float.firstMatch(input);

      // Then
      expect(match, isNotNull);
      expect(match?.group(1), equals('42.42'));
    });
  });
}

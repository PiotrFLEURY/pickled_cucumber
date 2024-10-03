import 'package:file/local.dart';
import 'package:pickled_cucumber/pickled_cucumber.dart';
import 'package:test/test.dart';

void main() {
  final pickledCucumber = PickledCucumber();
  group('extractOrderedArguments', () {
    group('string', () {
      test('single', () {
        // Given
        final sanitizedStep = 'today is {string}';
        final step = 'today is "Friday"';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, ['Friday']);
      });

      test('multiple', () {
        // Given
        final sanitizedStep = 'today is {string} and tomorrow is {string}';
        final step = 'today is "Friday" and tomorrow is "Saturday"';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, ['Friday', 'Saturday']);
      });
    });

    group('float', () {
      test('single', () {
        // Given
        final sanitizedStep = 'the calculator input is {float}';
        final step = 'the calculator input is 3.14';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, [3.14]);
      });

      test('multiple', () {
        // Given
        final sanitizedStep =
            'the calculator input is {float} and the other input is {float}';
        final step = 'the calculator input is 3.14 and the other input is 2.72';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, [3.14, 2.72]);
      });
    });

    group('int', () {
      test('single', () {
        // Given
        final sanitizedStep = 'the day number is {int}';
        final step = 'the day number is 3';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, [3]);
      });

      test('multiple', () {
        // Given
        final sanitizedStep =
            'the day number is {int} and the other day number is {int}';
        final step = 'the day number is 3 and the other day number is 4';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, [3, 4]);
      });
    });

    group('mix', () {
      test('string and float', () {
        // Given
        final sanitizedStep =
            'the day number is {int} and the other day number is {float}';
        final step = 'the day number is 3 and the other day number is 4.2';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, [3, 4.2]);
      });

      test('string and int', () {
        // Given
        final sanitizedStep =
            'the day number is {int} and the other day number is {string}';
        final step = 'the day number is 3 and the other day number is "4"';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, [3, '4']);
      });

      test('float and int', () {
        // Given
        final sanitizedStep =
            'the day number is {int} and the other day number is {float}';
        final step = 'the day number is 3 and the other day number is 4.2';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, [3, 4.2]);
      });

      test('string, float and int', () {
        // Given
        final sanitizedStep =
            'the day number is {int} and the other day number is {float} and the other other day number is {string}';
        final step =
            'the day number is 3 and the other day number is 4.2 and the other other day number is "5"';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, [3, 4.2, '5']);
      });

      test('human presentation', () {
        // Given
        final sanitizedStep =
            'Hello, my name is {string} {string} and I am {int} years old and I am {float} meters tall';
        final step =
            'Hello, my name is "Piotr" "FLEURY" and I am 37 years old and I am 1.79 meters tall';

        // When
        final arguments =
            pickledCucumber.extractOrderedArguments(sanitizedStep, step);

        // Then
        expect(arguments, ['Piotr', 'FLEURY', 37, 1.79]);
      });
    });
  });

  group('parseFeatures', () {
    test('should retreive all feature files inside a folder', () {
      final features = pickledCucumber.parseFeatures(
        LocalFileSystem(),
        'test/features',
      );

      expect(features.length, 2);
    });
  });
}

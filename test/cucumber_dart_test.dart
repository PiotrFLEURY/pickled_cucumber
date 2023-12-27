import 'package:cucumber_dart/cucumber_dart.dart';
import 'package:file/memory.dart';
import 'package:test/test.dart';

@StepDefinition()
class TestStepDefinitions {
  @Given("I have {int} {string} in my {string}")
  void iHaveCukesInMyBelly(int cukes, String belly, String string) {
    print('Cukes: $cukes');
    print('Belly: $belly');
  }

  @When("I wait {int} hour")
  void iWaitHour(int hour) {
    print('Hour: $hour');
  }

  @Then("my belly should growl")
  void myBellyShouldGrowl() {
    print('Growl!');
  }

  @And("I should have indigestion")
  void iShouldHaveIndigestion() {
    print('Indigestion!');
  }

  @And("I call an ineplemented step")
  void iCallUnIneplementedStep() {
    throw UnimplementedError();
  }

  @But("I have {float} {string} in my {string}")
  void iHaveCukesInMyBellyFloat(
    double cukes,
    String belly,
    String string,
  ) {
    print('Cukes: $cukes');
    print('Belly: $belly');
  }
}

/// The tests files does not contains any `test`function because the purpose
/// of this library is to generate tests to be run.
/// Dart does not allow to call `test` function inside an already running test.
/// This is why we use only `group` functions.
void main() {
  group('Simple test should pass', () {
    test('passing', () {
      // GIVEN
      final testFileSystem = MemoryFileSystem();

      final featureFileContent = '''
      Feature: Eating cukes makes me full
        Scenario: Eating
          Given I have 42 "cukes" in my "belly"
          When I wait 1 hour
          Then my belly should growl
          And I should have indigestion
          But I have 42.0 "cukes" in my "belly"
      ''';

      testFileSystem.directory('example/features').createSync(recursive: true);

      testFileSystem.file('example/features/simpleTest.feature')
        ..writeAsStringSync(featureFileContent)
        ..createSync(recursive: true);

      // WHEN
      final (int, int) report = CucumberDart().runFeatures(
        'example/features/',
        TestStepDefinitions(),
        fileSystem: testFileSystem,
        testMethod: (name, body) => body(),
      );

      // THEN
      expect(report, equals((1, 0)));
    });

    test('failing', () {
      // GIVEN
      final testFileSystem = MemoryFileSystem();

      final featureFileContent = '''
      Feature: Eating cukes makes me full
        Scenario: Fail eating
          Given I have 42 "cukes" in my "belly"
          When I wait 1 hour
          Then my belly should growl
          And I call an ineplemented step
      ''';

      testFileSystem.directory('example/features').createSync(recursive: true);

      testFileSystem.file('example/features/simpleTest.feature')
        ..writeAsStringSync(featureFileContent)
        ..createSync(recursive: true);

      // WHEN
      final (int, int) report = CucumberDart().runFeatures(
        'example/features/',
        TestStepDefinitions(),
        fileSystem: testFileSystem,
        testMethod: (name, body) => body(),
      );

      // THEN
      expect(report, equals((0, 1)));
    });
  });

  group('Multiple tests', () {
    test('all passing', () {
      // GIVEN
      final testFileSystem = MemoryFileSystem();

      final featureFileContent = '''
      Feature: Eating cukes makes me full
        Scenario: Eating success
          Given I have 42 "cukes" in my "belly"
          When I wait 1 hour
          Then my belly should growl
          And I should have indigestion

        Scenario: Eating success
          Given I have 42 "cukes" in my "belly"
          When I wait 1 hour
          Then my belly should growl
          And I should have indigestion
      ''';

      testFileSystem.directory('example/features').createSync(recursive: true);

      testFileSystem.file('example/features/simpleTest.feature')
        ..writeAsStringSync(featureFileContent)
        ..createSync(recursive: true);

      // WHEN
      final (int, int) report = CucumberDart().runFeatures(
        'example/features/',
        TestStepDefinitions(),
        fileSystem: testFileSystem,
        testMethod: (name, body) => body(),
      );

      // THEN
      expect(report, equals((2, 0)));
    });
    test('containing one failing', () {
      // GIVEN
      final testFileSystem = MemoryFileSystem();

      final featureFileContent = '''
      Feature: Eating cukes makes me full
        Scenario: Fail eating
          Given I have 42 "cukes" in my "belly"
          When I wait 1 hour
          Then my belly should growl
          And I call an ineplemented step

        Scenario: Eating success
          Given I have 42 "cukes" in my "belly"
          When I wait 1 hour
          Then my belly should growl
          And I should have indigestion
      ''';

      testFileSystem.directory('example/features').createSync(recursive: true);

      testFileSystem.file('example/features/simpleTest.feature')
        ..writeAsStringSync(featureFileContent)
        ..createSync(recursive: true);

      // WHEN
      final (int, int) report = CucumberDart().runFeatures(
        'example/features/',
        TestStepDefinitions(),
        fileSystem: testFileSystem,
        testMethod: (name, body) => body(),
      );

      // THEN
      expect(report, equals((1, 1)));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:pickled_cucumber/src/annotations.dart';

// This is an example of any class placed above the step definitions in the library file.
// The test should ensure that such classes do not interfere with the resolution of step methods.
class HelperClass {
  // Some properties and methods that are not related to step definitions
  bool checkSomething() {
    // Some helper method that is not a step definition
    return true;
  }
}

@StepDefinition()
class LibraryStepDefinitions {
  @Given('a library file with {int} classes and step definitions')
  Future<void> aLibraryFileWithMultipleClassesAndStepDefinitions(
    WidgetTester tester,
    int numberOfClasses,
  ) async {
    // Implementation pour une bibliothèque avec plusieurs classes et définitions d'étapes
  }

  @When('I resolve the step methods from the library file')
  Future<void> iResolveTheStepMethodsFromTheLibraryFile(
    WidgetTester tester,
  ) async {
    // Implementation pour résoudre les méthodes d'étape à partir du fichier de bibliothèque
  }

  @Then(
      'I should get a list of step methods that includes the method from the first class')
  Future<void>
      iShouldGetAListOfStepMethodsThatIncludesTheMethodFromTheFirstClass(
    WidgetTester tester,
  ) async {
    // Implementation pour vérifier que la liste des méthodes d'étape inclut la méthode de la première classe
  }
}

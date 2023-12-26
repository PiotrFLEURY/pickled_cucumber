import 'package:cucumber_dart/cucumber_dart.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:test/test.dart';
import '../routes/index.dart' as route;

class MockRequestContext extends mocktail.Mock implements RequestContext {}

class DartFrogStepDefinition {
  late MockRequestContext context;
  Response? response;

  @Given('my app is running')
  void myAppIsRunning() {
    context = MockRequestContext();
  }

  @When('I visit the index route')
  void iVisitTheIndexRoute() {
    response = route.onRequest(context);
  }

  @Then('I should see {string}')
  Future<void> iShouldSee(String string) async {
    expect(response!.body(), completion(equals(string)));
  }

  @And('receive a {int} status code')
  void receiveStatusCode(int statusCode) {
    expect(response!.statusCode, equals(statusCode));
  }
}

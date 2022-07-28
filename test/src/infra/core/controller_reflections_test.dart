import 'package:scouter/src/application/controller/rest_controller.dart';
import 'package:scouter/src/domain/http_controller.dart';
import 'package:scouter/src/domain/http_verbs.dart';
import 'package:scouter/src/domain/route.dart';
import 'package:scouter/src/infra/core/controller_reflections.dart';
import 'package:test/test.dart';

@HttpController()
class TestController extends RestController {
  @Get("/:id")
  Future<HttpResponse> getById(HttpRequest request) async {
    return HttpResponse(
      status: 200,
      body: {
        "tests": [],
      },
    );
  }

  @Post("/")
  Future<HttpResponse> save(HttpRequest request) async {
    final data = request.body;
    return HttpResponse(
      status: 201,
      body: data,
    );
  }
}

class WithoutAnnotationController extends RestController {}

@HttpController()
class Wrong extends RestController {}

void main() {
  test(
    'Should extract routes successfully',
    () async {
      final controller = TestController();
      final routes = ControllerReflections.getControllerRoutes(controller);

      expect(
        routes.length,
        equals(2),
      );
    },
  );

  test(
      "Should throw when trying to parse a controller without a http controller",
      () async {
    final controller = WithoutAnnotationController();

    expect(
      () => ControllerReflections.getControllerRoutes(controller),
      throwsArgumentError,
    );
  });

  test(
      "Should throw an exception when trying to parse a controller that does not contain controller on name",
      () async {
    final controller = Wrong();

    expect(
      () => ControllerReflections.getControllerRoutes(controller),
      throwsA(
        isException,
      ),
    );
  });
}

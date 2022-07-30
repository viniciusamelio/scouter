import 'package:scouter/src/application/controller/rest_controller.dart';
import 'package:scouter/src/domain/http_controller.dart';
import 'package:scouter/src/domain/http_verbs.dart';
import 'package:scouter/src/domain/route.dart';
import 'package:scouter/src/application/reflections/controller_reflections.dart';

import 'package:test/test.dart';

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

  test("Should throw when trying to declare a route which is empty", () async {
    final controller = WrongRouteDeclarationController();

    expect(
      () => ControllerReflections.getControllerRoutes(controller),
      throwsA(anything),
    );
  });

  test(
      "Should throw when trying to declare a route which does not begins with '/'",
      () async {
    final controller = WrongRouteDeclarationController2();

    expect(
      () => ControllerReflections.getControllerRoutes(controller),
      throwsA(anything),
    );
  });
}

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

@HttpController()
class WrongRouteDeclarationController extends RestController {
  @Get("")
  getById(HttpRequest request) async {
    return {};
  }
}

@HttpController()
class WrongRouteDeclarationController2 extends RestController {
  @Get("wrong")
  getById(HttpRequest request) async {
    return {};
  }
}

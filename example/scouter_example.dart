import 'package:fpdart/fpdart.dart';
import 'package:scouter/src/application/di/injections.dart';
import 'package:scouter/src/application/module/app_module.dart';
import 'package:scouter/src/domain/http_controller.dart';
import 'package:scouter/src/domain/http_verbs.dart';
import 'package:scouter/src/domain/middleware.dart';
import 'package:scouter/src/domain/route.dart';
// import 'package:scouter/src/infra/core/controller_reflections.dart';
import 'package:scouter/src/infra/start.dart';

@HttpController(name: "main")
class FeatureController extends RestController {
  FeatureController() {
    inject<FakeProvider>(
      SingletonInjection(
        FakeProvider(),
      ),
    );
  }

  @Get("/:id")
  HttpResponse getById(HttpRequest request) {
    return HttpResponse(
      body: {
        "id": request.params!["id"],
      },
      status: 200,
    );
  }

  @Post("/save")
  HttpResponse save(HttpRequest request) {
    final FakeProvider teste = get();
    return HttpResponse(
      body: {
        "teste": teste.name,
      },
      status: 201,
    );
  }
}

class ExampleMidleware implements HttpMiddleware {
  const ExampleMidleware();
  @override
  Future<Either<HttpResponse, void>> handle(HttpRequest request) async {
    if (request.path.contains("/game")) {
      return Left(
        HttpResponse(
          status: 400,
          body: {"status": "/game is not available"},
        ),
      );
    }
    return Right(null);
  }
}

@HttpController(
  middlewares: [
    ExampleMidleware(),
  ],
)
class GameController extends RestController {
  @Get("/")
  HttpResponse getById(HttpRequest request) {
    return HttpResponse(
      body: {"game": "Mario"},
      status: 202,
    );
  }
}

void main() async {
  // final routes = ControllerReflections.getControllerRoutes(
  //   FeatureController(),
  // );

  // for (var route in routes) {
  //   print("Path: ${route.path}");
  //   print("Method: ${route.verb}");
  // }

  runServer(
    AppModule(
      controllers: [
        FeatureController(),
        GameController(),
      ],
    ),
    port: 8084,
  );
}

class FakeProvider {
  String name = "fakezão";
}

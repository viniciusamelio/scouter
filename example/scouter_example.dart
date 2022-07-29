import 'package:fpdart/fpdart.dart';
import 'package:scouter/src/application/controller/rest_controller.dart';
import 'package:scouter/src/application/di/injections.dart';
import 'package:scouter/src/application/module/app_module.dart';
import 'package:scouter/src/domain/http_controller.dart';
import 'package:scouter/src/domain/http_verbs.dart';
import 'package:scouter/src/domain/middleware.dart';
import 'package:scouter/src/domain/module.dart';
import 'package:scouter/src/domain/route.dart';
import 'package:scouter/src/infra/core/response_reflections.dart';
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
    );
  }

  @Post("/save")
  HttpResponse save(HttpRequest request) {
    final FakeProvider teste = get();
    return HttpResponse(
      body: {
        "teste": teste.name,
      },
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

@HttpController()
class ProfileController extends RestController {
  @Get("/private")
  getById(HttpRequest request) {
    return Resposta();
  }
}

class Resposta {
  List<Teste> respostas = [
    Teste(),
    Teste(),
    Teste(),
  ];
  String message = "Salvo com sucesso!";
  int savedId = 70;
  int httpStatus = 206;
}

class Teste {
  String data = "ok";
}
// TODO: Implementar middlewares a nível de módulo

class TestModule extends Module {
  TestModule({super.preffix = "teste"});

  @override
  List<RestController> get controllers => [
        GameController(),
        ProfileController(),
      ];

  @override
  List<HttpMiddleware> get middlewares => [];
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
      modules: [
        TestModule(),
      ],
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

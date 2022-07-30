import "package:scouter/scouter.dart";

@HttpController()
class FeatureController extends RestController {
  FeatureController() {
    inject<FakeProvider>(
      SingletonInjection(
        FakeProvider(),
      ),
    );
  }

  @Get("/:id")
  getById(HttpRequest request) {
    return {
      "id": request.params!["id"],
    };
  }

  @Post("/save")
  HttpResponse save(HttpRequest request) {
    final FakeProvider teste = injected();
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

class LoggerMiddleware implements HttpMiddleware {
  @override
  Future<Either<HttpResponse, void>> handle(HttpRequest request) async {
    if (request.path.contains("/private")) {
      return Left(HttpResponse(
        body: {
          "request": request.body,
        },
        status: 500,
      ));
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

  @Get("/")
  get(HttpRequest request) {
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

  void call() {}
}

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
      middlewares: [
        ExampleMidleware(),
        LoggerMiddleware(),
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

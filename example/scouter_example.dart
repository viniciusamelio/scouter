import "package:scouter/scouter.dart";
import 'package:scouter/src/application/dto/mappable_input.dart';

class ComplexDto extends MappableInput {
  ComplexDto({
    this.name,
    this.xesquedele,
    this.data,
  });
  final String? name;
  final int? xesquedele;
  final List<Data>? data;

  @override
  MappableInput parse(dynamic map) {
    return ComplexDto(
      name: map["name"],
      xesquedele: map["xesquedele"],
      data: (map["data"] as List)
          .map((e) => Data(status: e["status"], id: e["id"]))
          .toList(),
    );
  }
}

class Data {
  const Data({
    required this.status,
    required this.id,
  });
  final String status;
  final int id;
}

class User {
  const User({required this.name, required this.age});

  final String name;
  final int age;
}

@HttpController()
class FeatureController extends RestController {
  FeatureController() {
    inject<FakeProvider>(
      SingletonInjection(
        FakeProvider(),
      ),
    );
  }
  @Post("/:id/:uid/")
  getById(int id, String uid, @Body() ComplexDto dto) {
    return {
      "id": dto,
    };
  }

  @Post("/save/user")
  saveUser(@Body() User user) {
    return user;
  }

  @Post("/save/:id")
  HttpResponse save(int id) {
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
    return {
      "data": Resposta(),
    };
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
  String httpStatus = "203";
}

class Teste {
  String data = "ok";

  void call() {}
}

class TestModule extends Module {
  TestModule({super.preffix});

  @override
  List<RestController> get controllers => [
        GameController(),
        ProfileController(),
      ];

  @override
  List<HttpMiddleware> get middlewares => [];
}

void main() async {
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
      init: () => print("Starting up"),
    ),
    port: 8080,
  );
}

class FakeProvider {
  String name = "fakezão";
}

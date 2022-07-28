import 'package:scouter/src/application/module/app_module.dart';
import 'package:scouter/src/domain/http_controller.dart';
import 'package:scouter/src/domain/http_verbs.dart';
import 'package:scouter/src/domain/route.dart';
import 'package:scouter/src/infra/core/controller_reflections.dart';
import 'package:scouter/src/infra/start.dart';

@HttpController(name: "main")
class FeatureController extends RestController {
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
    return HttpResponse(
      body: {},
      status: 201,
    );
  }
}

void main() async {
  final routes = ControllerReflections.getControllerRoutes(
    FeatureController(),
  );

  for (var route in routes) {
    print("Path: ${route.path}");
    print("Method: ${route.verb}");
  }

  runServer(
    AppModule(
      controllers: [
        FeatureController(),
      ],
    ),
    port: 8084,
  );
}

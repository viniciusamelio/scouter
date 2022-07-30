import 'package:scouter/src/domain/module.dart';

import "../../domain/middleware.dart";
import '../controller/rest_controller.dart';

class AppModule implements Module {
  const AppModule({
    this.controllers = const [],
    this.modules = const [],
    this.middlewares = const [],
    this.globalMiddlewares = const [],
  });

  @override
  final String preffix = "";

  @override
  final List<RestController> controllers;

  final List<Module> modules;

  @override
  final List<HttpMiddleware> middlewares;

  final List<HttpMiddleware> globalMiddlewares;
}

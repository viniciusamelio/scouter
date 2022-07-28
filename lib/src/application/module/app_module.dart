import 'package:scouter/src/domain/http_controller.dart';
import 'package:scouter/src/domain/module.dart';

import "../../domain/middleware.dart";

class AppModule implements Module {
  const AppModule({
    this.controllers = const [],
    this.modules = const [],
    this.middlewares = const [],
  });

  @override
  final String preffix = "/";

  @override
  final List<RestController> controllers;

  final List<Module> modules;

  @override
  final List<HttpMiddleware> middlewares;
}

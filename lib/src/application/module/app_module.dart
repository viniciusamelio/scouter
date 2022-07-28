import 'package:scouter/src/domain/http_controller.dart';
import 'package:scouter/src/domain/di.dart';
import 'package:scouter/src/domain/module.dart';

import "../../domain/middleware.dart";

class AppModule implements Module {
  const AppModule({
    this.exports = const [],
    this.imports = const [],
    this.controllers = const [],
    this.providers = const [],
    this.modules = const [],
    this.middlewares = const [],
  });

  @override
  final List<Injection<Object>> exports;

  @override
  final List<Module> imports;

  @override
  final String preffix = "/";

  @override
  final List<RestController> controllers;

  @override
  final List<Injection<Object>> providers;

  final List<Module> modules;

  @override
  final List<HttpMiddleware> middlewares;
}

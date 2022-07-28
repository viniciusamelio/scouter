import 'package:scouter/src/domain/di.dart';
import 'package:scouter/src/domain/http_controller.dart';
import 'package:scouter/src/domain/middleware.dart';

abstract class Module {
  const Module({
    required this.preffix,
    this.providers = const [],
    this.exports = const [],
    this.imports = const [],
    this.controllers = const [],
    this.middlewares = const [],
  });

  final List<RestController> controllers;
  final List<Injection> providers;

  final List<Module> imports;
  final List<Injection> exports;
  final List<HttpMiddleware> middlewares;

  final String preffix;
}

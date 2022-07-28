import 'package:scouter/src/domain/middleware.dart';

import '../application/controller/rest_controller.dart';

abstract class Module {
  const Module({
    required this.preffix,
    this.controllers = const [],
    this.middlewares = const [],
  });

  final List<RestController> controllers;
  final List<HttpMiddleware> middlewares;

  final String preffix;
}

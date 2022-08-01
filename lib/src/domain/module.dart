import 'package:scouter/src/domain/middleware.dart';

import '../application/controller/rest_controller.dart';

abstract class Module {
  Module({
    required this.preffix,
    this.controllers = const [],
    this.middlewares = const [],
  }) : assert(
          preffix[0] != "/",
          "A Module's preffix must not start with '/' ",
        );

  final List<RestController> controllers;
  final List<HttpMiddleware> middlewares;

  final String preffix;
}

import 'package:scouter/src/domain/middleware.dart';

import '../application/controller/rest_controller.dart';

/// A Module represents a context of your software. Each Module have its own controllers and middlewares.<br>
/// A Module needs to be extended and its preffix property will declare a part of your routes.
///
/// ```dart
///class AnyModule extends Module{
///  AnyModule({super.preffix = "any"})
///
/// ...
///}
/// ```
///
/// The example above will make every route inside any controller of it follow this format: /any/controller/route
abstract class Module {
  Module({
    this.preffix,
    this.controllers = const [],
    this.middlewares = const [],
    this.init,
  }) : assert(
          preffix?[0] != "/",
          "A Module's preffix must not start with '/' ",
        );

  final List<RestController> controllers;
  final List<HttpMiddleware> middlewares;

  final String? preffix;

  /// This function will be executed when module is parsed, when application is upping. <br>
  /// You can use it to inject global scoped dependencies, for example.
  final Future<void> Function()? init;
}

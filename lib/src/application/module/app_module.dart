import 'dart:html';

import 'package:scouter/src/domain/module.dart';

import "../../domain/middleware.dart";
import '../controller/rest_controller.dart';

/// Your application root module, here you will add your modules, controllers, etc. <br>
/// It must be your application entry point, which should be provided to the runServer() function
class AppModule implements Module {
  const AppModule({
    this.controllers = const [],
    this.modules = const [],
    this.middlewares = const [],
    this.globalMiddlewares = const [],
  });

  @override
  final String preffix = "";

  /// Your app module controllers. Every controller added here, will get route following this format: <b> /yourcontroller/route </b>
  @override
  final List<RestController> controllers;

  /// Other modules that you may create along the development will be added here. <br>
  /// Every other module than AppModule will be accessible through: <b> /yourmodulepreffix/controller/route </b>
  final List<Module> modules;

  /// Middlewares added here will only be applied to controllers added to this module (AppModule)
  @override
  final List<HttpMiddleware> middlewares;

  /// Middlewares added here will be added to every single route in your application. Be careful
  final List<HttpMiddleware> globalMiddlewares;

  @override
  VoidCallback? get init => null;
}

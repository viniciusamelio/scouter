import 'package:scouter/src/application/di/injector.dart';
import 'package:scouter/src/domain/middleware.dart';

import 'di.dart';

class HttpController {
  const HttpController({
    this.name = "",
    this.dependencies = const [],
    this.middlewares = const [],
  });
  final String? name;
  final List<Injection> dependencies;
  final List<HttpMiddleware>? middlewares;
}

abstract class RestController {
  String? preffix = "";
  final _injector = KiwiInjector.instance;

  void inject<T extends Object>(Injection<T> injection) {
    _injector.register<T>(injection);
  }

  T get<T>([String? name]) => _injector.get<T>(name);
}

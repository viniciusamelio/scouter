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

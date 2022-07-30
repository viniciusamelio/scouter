import 'package:scouter/src/domain/middleware.dart';

class HttpController {
  const HttpController({
    this.name = "",
    this.middlewares = const [],
  });
  final String? name;
  final List<HttpMiddleware>? middlewares;
}

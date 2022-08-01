import 'package:scouter/src/domain/middleware.dart';

/// HttpController is an Annotation that declares a Controller, that <b>must</b> also extends a RestController
class HttpController {
  const HttpController({
    this.name = "",
    this.middlewares = const [],
  });
  final String? name;
  final List<HttpMiddleware>? middlewares;
}

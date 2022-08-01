import 'package:scouter/src/domain/middleware.dart';

typedef RouteHandler = Future<dynamic> Function(
  HttpRequest request,
);

class HttpRequest {
  HttpRequest({
    required this.headers,
    required this.path,
    this.body,
    this.params,
    this.middlewares = const [],
  });
  final String path;
  final Map<String, dynamic> headers;
  final dynamic body;
  final Map<String, dynamic>? params;
  final List<HttpMiddleware> middlewares;
}

class HttpResponse {
  HttpResponse({
    this.status,
    required this.body,
    this.headers = const {},
  });

  final int? status;
  final Map<String, dynamic> body;
  final Map<String, dynamic> headers;
}

class HttpRoute {
  HttpRoute({
    required this.handler,
    required this.path,
    this.verb = "get",
    this.middlewares,
    this.preffix,
  }) : assert(
          path.isNotEmpty && path[0] == "/",
          "Route path should begins with '/'",
        );
  final String path;
  final RouteHandler handler;
  final String verb;
  String? preffix;
  List<HttpMiddleware>? middlewares;
}

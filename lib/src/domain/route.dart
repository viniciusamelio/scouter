import 'package:scouter/src/domain/middleware.dart';

typedef RouteHandler = Future<HttpResponse> Function(
  HttpRequest request,
);

class HttpRequest {
  HttpRequest({
    required this.headers,
    this.body,
    this.params,
  });
  final dynamic headers;
  final dynamic body;
  final Map<String, dynamic>? params;
}

class HttpResponse {
  HttpResponse({
    required this.status,
    required this.body,
    this.headers = const {},
  });

  final int status;
  final Map<String, dynamic> body;
  final Map<String, dynamic> headers;
}

class HttpRoute {
  HttpRoute({
    required this.handler,
    required this.path,
    this.verb = "get",
    this.middleware,
  });
  final String path;
  final RouteHandler handler;
  final String verb;
  final HttpMiddleware? middleware;
}

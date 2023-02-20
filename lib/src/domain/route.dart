import 'package:scouter/src/domain/middleware.dart';

/// The function to run when a route is requested
typedef RouteHandler = Future<dynamic> Function(
  HttpRequest request,
);

/// A Request object, which should always be placed as an argument for a route handler
class HttpRequest {
  HttpRequest({
    required this.headers,
    required this.path,
    this.body,
    this.params,
    this.middlewares = const [],
    this.queryParams = const {},
  });

  /// Requested url
  final String path;

  /// Request headers
  final Map<String, dynamic> headers;

  // Query params
  final Map<String, dynamic> queryParams;

  /// Request body sent, it can be null
  final dynamic body;

  /// Url params given by dynamic routes, such as /foo/:id<br>
  /// You can access the sample param above as: request.params!["id"]
  final Map<String, dynamic>? params;

  /// Middlewares applied to this request
  final List<HttpMiddleware> middlewares;
}

/// Your route response
class HttpResponse {
  HttpResponse({
    this.status,
    required this.body,
    this.headers = const {},
  });

  /// It can be null, so, the default status will be 200
  final int? status;

  /// Your response body
  final Map<String, dynamic> body;

  /// Your response headers
  final Map<String, dynamic> headers;
}

/// Routes declared in a @HttpController are nothing but a http route like this
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

  /// The endpoint uri
  final String path;

  /// Function that handles sent [HttpRequest] and send a [HttpResponse]
  final RouteHandler handler;
  final String verb;
  String? preffix;

  /// Middlewares applied to this endpoint. It is useful for debugging
  List<HttpMiddleware>? middlewares;
}

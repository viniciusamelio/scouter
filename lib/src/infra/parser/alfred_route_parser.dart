import 'package:alfred/alfred.dart' as alfred;
import 'package:scouter/src/application/reflections/response_reflections.dart';
import 'package:scouter/src/domain/middleware.dart';
import 'package:scouter/src/domain/route.dart';

import 'alfred_headers_parser.dart';

class AlfredRouteParser {
  static alfred.HttpRoute parse(HttpRoute route) {
    return alfred.HttpRoute(
      "${route.preffix}${route.path}",
      (req, res) => _handlerParser(
        req,
        res,
        route.handler,
        route.middlewares,
        route.verb,
      ),
      _methodParser(route.verb),
    );
  }
}

/// It Converts Alfred to Scouter Needs Objects
_handlerParser(
  alfred.HttpRequest req,
  alfred.HttpResponse res,
  RouteHandler handler,
  List<HttpMiddleware>? middlewares,
  String httpVerb,
) async {
  final Map<String, dynamic> headers = AlfredHeadersParser.parse(req);
  final request = HttpRequest(
    headers: headers,
    body: await req.body,
    params: req.params,
    path: req.route,
    queryParams: req.uri.queryParameters,
  );
  final response = ResponseReflections.getResponseFromObject(
    await handler(request),
  );
  res.statusCode = _setStatusCode(
    httpVerb: httpVerb,
    responseStatus: response.status,
  );

  for (var key in response.headers.keys) {
    res.headers.add(key, response.headers[key]);
  }

  await _applyMiddleware(
    middlewares,
    request,
  );

  return res.json(response.body);
}

alfred.Method _methodParser(String httpVerb) {
  switch (httpVerb) {
    case "get":
      return alfred.Method.get;
    case "post":
      return alfred.Method.post;
    case "options":
      return alfred.Method.options;
    case "delete":
      return alfred.Method.delete;
    case "put":
      return alfred.Method.put;
    case "patch":
      return alfred.Method.patch;
    case "head":
      return alfred.Method.head;
    default:
      return alfred.Method.get;
  }
}

int _setStatusCode({
  required String httpVerb,
  int? responseStatus,
}) {
  if (responseStatus == null) {
    if (httpVerb == "post") {
      return 201;
    }
    return 200;
  }
  return responseStatus;
}

/// It applies the middleware list related to the controller, that is passed to each route inside it
Future _applyMiddleware(
  List<HttpMiddleware>? middlewares,
  HttpRequest request,
) async {
  if (middlewares != null) {
    for (var middleware in middlewares) {
      final responseOrNull = await middleware.handle(request);
      responseOrNull.fold(
        (l) => throw alfred.AlfredException(
          l.status ?? 500,
          l.body,
        ),
        (r) => null,
      );
    }
  }
}

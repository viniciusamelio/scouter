import 'package:alfred/alfred.dart' as alfred;
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
) async {
  final Map<String, dynamic> headers = AlfredHeadersParser.parse(req);
  final request = HttpRequest(
    headers: headers,
    body: await req.body,
    params: req.params,
    path: req.route,
  );
  final response = await handler(request);
  res.statusCode = response.status;

  for (var key in response.headers.keys) {
    res.headers.add(key, response.headers[key]);
  }

  _applyMiddleware(
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

_applyMiddleware(
  List<HttpMiddleware>? middlewares,
  HttpRequest request,
) {
  if (middlewares != null) {
    for (var middleware in middlewares) {
      middleware.handle(request);
    }
  }
}

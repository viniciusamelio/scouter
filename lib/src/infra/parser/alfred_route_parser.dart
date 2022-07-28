import 'package:alfred/alfred.dart' as alfred;
import 'package:scouter/src/domain/route.dart';

import 'alfred_headers_parser.dart';

class AlfredRouteParser {
  static alfred.HttpRoute parse(HttpRoute route) {
    return alfred.HttpRoute(
      route.path,
      (req, res) => _handlerParser(
        req,
        res,
        route.handler,
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
) async {
  final Map<String, dynamic> headers = AlfredHeadersParser.parse(req);
  final request = HttpRequest(
    headers: headers,
    body: await req.body,
    params: req.params,
  );
  final response = await handler(request);
  res.statusCode = response.status;

  for (var key in response.headers.keys) {
    res.headers.add(key, response.headers[key]);
  }

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

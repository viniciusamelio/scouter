import 'dart:async';

import 'package:alfred/alfred.dart' as alfred;
import 'package:scouter/src/domain/middleware.dart';
import 'package:scouter/src/domain/route.dart';

import 'alfred_headers_parser.dart';

class AlfredMiddlewareParser {
  static FutureOr<dynamic> Function(
    alfred.HttpRequest,
    alfred.HttpResponse,
  ) parse(HttpMiddleware middleware) {
    return (req, res) async {
      final Map<String, dynamic> headers = AlfredHeadersParser.parse(req);
      final request = HttpRequest(headers: headers);
      return middleware.handle(
        request,
      );
    };
  }
}

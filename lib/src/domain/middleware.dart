import 'package:scouter/src/domain/route.dart';

abstract class HttpMiddleware {
  Future<void> handle(HttpRequest request);
}

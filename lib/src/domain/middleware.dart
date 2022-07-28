import 'package:fpdart/fpdart.dart';
import 'package:scouter/src/domain/route.dart';

abstract class HttpMiddleware {
  Future<Either<HttpResponse, void>> handle(HttpRequest request);
}

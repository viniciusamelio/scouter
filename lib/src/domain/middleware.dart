import 'package:fpdart/fpdart.dart';
import 'package:scouter/src/domain/route.dart';

/// A Middleware runs before a http route handler. You must implement it, and make the constructor const, before adding to a controller or module. <br>
/// To return something from a middleware, you should use a Left() return:
/// ```dart
///   Future<Either<HttpResponse, void>> handle(HttpRequest request){
///     if(...){
///       return Left(HttpResponse(status: 400, body: {"message" : "error"}));
///     }
///     ...
///   }
/// ```
/// If you want to proceed to your endpoint, you can just return a Right(null):
///```dart
///   Future<Either<HttpResponse, void>> handle(HttpRequest request){
///     return Right(null);
///   }
/// ```
abstract class HttpMiddleware {
  Future<Either<HttpResponse, void>> handle(HttpRequest request);
}

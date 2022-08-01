import '../di/injectable.dart';

/// RestController is a class that Controllers must extend to be implemented to [Modules].
/// It is decorated with Injectable Mixin, it means that every RestController has access to DI functions inject<T>() and injected<T>()
abstract class RestController with Injectable {
  /// Preffix should be setted through @HttpController annotation, you can just ignore it.
  String? preffix = "";
}

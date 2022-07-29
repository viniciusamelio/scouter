import '../../domain/di.dart';
import 'injector.dart';

mixin Injectable {
  final _injector = KiwiInjector.instance;

  void inject<T extends Object>(Injection<T> injection) {
    _injector.register<T>(injection);
  }

  T injected<T>([String? name]) => _injector.get<T>(name);
}

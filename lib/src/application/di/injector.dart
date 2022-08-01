import 'package:kiwi/kiwi.dart';
import 'package:scouter/src/application/di/injections.dart';
import 'package:scouter/src/domain/di.dart';

/// A Kiwi implementation of our abstraction [InjectionManager]. <br>
/// You can also do your own implementation if you wish.
class KiwiInjector implements InjectionManager<KiwiContainer> {
  @override
  T get<T>([String? name]) {
    return injector<T>(name);
  }

  @override
  final KiwiContainer injector = KiwiContainer();

  KiwiInjector._internal();

  static final KiwiInjector instance = KiwiInjector._internal();

  /// Receives a Injection and register it according to its type (Factory or Singleton)
  @override
  void register<T extends Object>(Injection<T> injection) {
    final injectionInstance = injection;
    if (injection is FactoryInjection) {
      injector.registerFactory<T>(
        (container) => injectionInstance.builder(),
        name: injectionInstance.name,
      );
      return;
    }

    injector.registerSingleton<T>(
      (container) => injectionInstance.builder(),
      name: injectionInstance.name,
    );
  }
}

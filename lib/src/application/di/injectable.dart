import '../../domain/di.dart';
import 'injector.dart';

/// A Mixin that provides Dependency Injection functions.
mixin Injectable {
  final _injector = KiwiInjector.instance;

  /// Function to inject dependencies:
  /// ```dart
  /// inject<YourClass>( FactoryInjection( () => YourClass()) );
  /// ```
  /// You can optionally provide a name to your container:
  /// ```dart
  /// inject<YourClass>( FactoryInjection( () => YourClass(), name: "little_service") );
  /// ```
  void inject<T extends Object>(Injection<T> injection) {
    _injector.register<T>(injection);
  }

  /// Function to retrieve injected dependencies:
  /// ```dart
  /// injected<YourClass>();
  /// ```
  /// To retrieve named containers:
  /// ```dart
  /// injected<YourClass>("little_service");
  /// ```
  T injected<T>([String? name]) => _injector.get<T>(name);
}

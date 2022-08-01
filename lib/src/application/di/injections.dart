import 'package:scouter/src/domain/di.dart';

/// Represents a Singleton instance to be injected
/// ```dart
/// SingletonInjection<YourClass>(Yourclass())
/// ```
/// To inject a named container:
/// ```dart
/// SingletonInjection<YourClass>(Yourclass(), name: "Your Name")
/// ```
class SingletonInjection<T extends Object> implements Injection<T> {
  SingletonInjection(
    this.instance, {
    this.name,
  });

  final T instance;

  @override
  Builder<T> get builder => () => instance;

  @override
  final String? name;

  @override
  Type type = T;
}

/// Represents  a Factory instance to be injected
/// ```dart
/// FactoryInjection<YourClass>(() => Yourclass())
/// ```
/// To inject a named container:
/// ```dart
/// FactoryInjection<YourClass>(()=>Yourclass(), named: "Your name")
/// ```
class FactoryInjection<T extends Object> implements Injection<T> {
  FactoryInjection(
    this.instance, {
    this.name,
  });
  final Builder<T> instance;

  @override
  Builder<T> get builder => instance;

  @override
  final String? name;

  @override
  Type type = T;
}

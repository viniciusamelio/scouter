import 'package:scouter/src/domain/di.dart';

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

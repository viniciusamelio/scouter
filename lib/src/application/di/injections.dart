import 'package:scouter/src/domain/di.dart';

class SingletonInjection<T> implements Injection<T> {
  SingletonInjection(
    this.instance, {
    this.name,
  });

  final T instance;

  @override
  Builder<T> get builder => () => instance;

  @override
  final String? name;
}

class FactoryInjection<T> implements Injection<T> {
  FactoryInjection(
    this.instance, {
    this.name,
  });
  final Builder<T> instance;

  @override
  Builder<T> get builder => instance;

  @override
  final String? name;
}

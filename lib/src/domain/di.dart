typedef Builder<T extends Object> = void Function(T instance);

abstract class Injection<T extends Object> {
  const Injection(
    this.builder, {
    this.name,
  });
  final String? name;
  final Builder<T> builder;
}

abstract class InjectionManager<Injector> {
  InjectionManager({
    required this.injector,
  });
  final Injector injector;

  void registerSingleton<T>(Injection instance);
  void registerFactory<T>(Injection instance);

  T get<T>([String? name]);
}

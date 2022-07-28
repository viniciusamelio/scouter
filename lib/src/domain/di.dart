typedef Builder<T> = T Function();

abstract class Injection<T> {
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

  void register<T>(Injection<T> instance);

  T get<T>([String? name]);
}

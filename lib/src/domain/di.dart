typedef Builder<T> = T Function();

abstract class Injection<T extends Object> {
  Injection(
    this.builder, {
    this.name,
  });
  final String? name;
  final Builder<T> builder;
  Type type = T.runtimeType;
}

abstract class InjectionManager<Injector> {
  InjectionManager({
    required this.injector,
  });
  final Injector injector;

  void register<T extends Object>(Injection<T> instance);

  T get<T>([String? name]);
}

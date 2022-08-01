typedef Builder<T> = T Function();

/// Injection is a wrapper of an instance to be injected
abstract class Injection<T extends Object> {
  Injection(
    this.builder, {
    this.name,
  });
  final String? name;
  final Builder<T> builder;
  Type type = T.runtimeType;
}

/// Injection Manager is an interface to handle container registration
abstract class InjectionManager<Injector> {
  InjectionManager({
    required this.injector,
  });
  final Injector injector;

  void register<T extends Object>(Injection<T> instance);

  T get<T>([String? name]);
}

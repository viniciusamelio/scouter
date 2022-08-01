import 'package:scouter/src/domain/module.dart';
import 'package:test/test.dart';

class Sut extends Module {
  Sut({required super.preffix});
}

void main() {
  test('Should not instantiate a Module which preffix starts with "/" ',
      () async {
    expect(
      () => Sut(preffix: "/"),
      throwsA(anything),
    );
  });

  test("Should instantiate a Module which preffix does not start with '/' ",
      () async {
    final sut = Sut(preffix: "main");
    expect(
      sut,
      isA<Sut>(),
    );
  });
}

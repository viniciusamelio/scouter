import 'package:faker/faker.dart';
import 'package:scouter/src/application/reflections/response_reflections.dart';
import 'package:test/test.dart';

void main() {
  test("Should parse a custom object successfully to a HttpResponse", () async {
    final dto = Dto();

    final response = ResponseReflections.getResponseFromObject(dto);

    expect(
      response.body.containsKey("firstName"),
      isTrue,
    );
    expect(
      response.body.containsKey("lastName"),
      isTrue,
    );
    expect(
      response.body.containsKey("age"),
      isTrue,
    );
    expect(
      response.body.containsValue("Vinicius"),
      isTrue,
    );
    expect(
      response.body.containsValue("Amélio"),
      isTrue,
    );
    expect(
      response.body.containsValue(22),
      isTrue,
    );
  });

  test(
      "Should set response status as 200 by default, when no httpStatus field is passed to the returned object",
      () async {
    final dto = Dto();

    final response = ResponseReflections.getResponseFromObject(dto);

    expect(response.status, equals(200));
  });

  test("Should set response status according to httpStatus field", () async {
    final num desiredStatus = 202;
    final dto = Dto(desiredStatus);

    final response = ResponseReflections.getResponseFromObject(dto);

    expect(response.status, equals(desiredStatus));
  });

  test(
      "Should call toMap method when response object contains it, instead of parsing the instance",
      () async {
    final dto = ToMapDto();

    final response = ResponseReflections.getResponseFromObject(dto);

    expect(response.status, equals(201));
    expect(response.body["foo"], equals(dto.foo));
    expect(response.body["bar"], equals(dto.bar));
    expect(response.body.containsKey("id"), isFalse);
  });

  test(
      "Should call toJson method when response object contains it, instead of parsing the instance",
      () async {
    final dto = ToJsonDto();

    final response = ResponseReflections.getResponseFromObject(dto);

    expect(response.status, equals(202));
    expect(response.body["foo"], equals(dto.foo));
    expect(response.body["bar"], equals(dto.bar));
    expect(response.body.containsKey("id"), isFalse);
  });

  test("Should parse custom type property object successfully", () async {
    final dto = CustomTypeDto();

    final response = ResponseReflections.getResponseFromObject(dto);

    expect(response.status, equals(200));
    expect(response.body["user"], isA<Map<String, dynamic>>());
    expect(response.body["user"]["email"], equals(dto.user.email));
  });

  test("Should parse custom type list successfully", () async {
    final dto = CustomListTypeDto();

    final response = ResponseReflections.getResponseFromObject(dto);

    expect(response.status, equals(200));
    expect(response.body["employees"], isA<List<Map<String, dynamic>>>());
    expect(response.body["employees"].first["email"],
        equals(dto.employees.first.email));
    expect(response.body["employees"].first["login"],
        equals(dto.employees.first.login));
  });

  test("Should not parse methods", () async {
    final dto =
        User(email: faker.internet.email(), login: faker.internet.userName());

    final response = ResponseReflections.getResponseFromObject(dto);

    expect(response.body.containsKey("getId"), isFalse);
  });
}

class CustomListTypeDto {
  String mainEmail = faker.internet.email();

  List<User> employees = [
    User(email: faker.internet.email(), login: faker.internet.userName()),
    User(email: faker.internet.email(), login: faker.internet.userName()),
    User(email: faker.internet.email(), login: faker.internet.userName()),
  ];
}

class CustomTypeDto {
  final User user =
      User(email: faker.internet.email(), login: faker.internet.userName());
  final bankAccountNumber = faker.guid.guid();
}

class User {
  User({
    required this.email,
    required this.login,
  });
  final String login;
  final String email;

  int getId() => 5;
}

class ToJsonDto {
  String foo = "Jaina";
  String bar = "Proudmore";
  int id = 51;

  Map<String, dynamic> toMap() => {
        "foo": foo,
        "bar": bar,
        "httpStatus": 202,
      };
}

class Dto {
  Dto([this.httpStatus]);
  String firstName = "Vinicius";
  String lastName = "Amélio";
  num age = 22;
  num? httpStatus;
}

class ToMapDto {
  String foo = "Leroy";
  String bar = "Jenkins";
  int id = 50;

  Map<String, dynamic> toMap() => {
        "foo": foo,
        "bar": bar,
        "httpStatus": 201,
      };
}

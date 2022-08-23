import 'dart:mirrors';

import '../../domain/route.dart';

abstract class RequestParameterReflections {
  static List<dynamic> handleUrlParams(
    HttpRequest request,
    List<MapEntry<Type, String>> declaredParams,
  ) {
    List<dynamic> listParams = [];
    final splittedPath =
        request.path.split(":").map((e) => e.replaceAll("/", "")).toList();
    if (splittedPath.length > 1) {
      splittedPath.removeAt(0);
      for (var pathParam in splittedPath) {
        if (declaredParams
            .where((element) =>
                element.value == pathParam && element.key.toString() == "int")
            .isNotEmpty) {
          listParams.add(int.tryParse(request.params![pathParam]) ?? 0);
          continue;
        }
        listParams.add(request.params![pathParam]);
      }
    }
    return listParams;
  }

  static handleBodyParams(
    MapEntry<Type, String> e,
    HttpRequest request,
    List<ParameterMirror> parameters,
  ) {
    if (e.key.toString() == "int") {
      return int.parse(request.body[e.value]);
    } else if (e.key.toString() == "String") {
      return request.body[e.value];
    } else if (e.key.toString() == "HttpRequest") {
      return request;
    }
    final dtoType = parameters.last.type.reflectedType;
    final reflectedDto = reflectClass(dtoType);

    final Map<Symbol, dynamic> arguments = {};
    reflectedDto.declarations.forEach((symbol, member) {
      if (member.owner!.simpleName == member.simpleName ||
          (member is MethodMirror)) {
        return;
      }
      // TODO: Fazer o parse de acordo com o tipo declarado no DTO, caso for um tipo nativo, apenas retornar
      // Se por acaso for um tipo próprio, fazer o parsing através das declarations da classe
      final keyString = member.simpleName.toString().split('"')[1];
      final key = member.simpleName;
      arguments.addAll(
        {
          key: request.body[keyString],
        },
      );
    });

    return reflectedDto
        .newInstance(
          reflectedDto.owner!.simpleName,
          [],
          arguments,
        )
        .reflectee;
  }
}

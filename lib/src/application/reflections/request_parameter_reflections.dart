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

  static final Map<Type, bool> nativeAcceptedPropTypes = {
    bool: true,
    String: true,
    Map: true,
    num: true,
    int: true,
    double: true,
    Null: true,
    List<String>: true,
    List<int>: true,
    List: true,
    List<Map>: true,
    List<Map<String, dynamic>>: true,
    List<double>: true,
    List<num>: true,
    List<List>: true,
  };

  static handleBodyParams(
    MapEntry<Type, String> e,
    HttpRequest request,
    List<ParameterMirror> parameters,
  ) {
    if (nativeAcceptedPropTypes.containsKey(e.key)) {
      return request.body[e.value];
    } else if (e.key == HttpRequest) {
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
      final keyString = member.simpleName.toString().split('"')[1];
      final key = member.simpleName;
      var value = request.body[keyString];
      final valueType = (member as VariableMirror).type.reflectedType;

      if (!nativeAcceptedPropTypes.containsKey(valueType)) {
        final isIterable =
            reflectType(valueType).isSubtypeOf(reflectType(List));
        if (isIterable &&
            !nativeAcceptedPropTypes
                .containsKey((value as List).first.runtimeType)) {
          final valueTypeGeneric =
              reflectType(valueType).typeArguments.first.reflectedType;
          // value = value
          //     .map((e) => _parseCustomDtoVariable(valueType, request, e))
          //     .toList();
          // TODO: Preciso conseguir fazer o cast do objeto
          value = value
              .map(
                (e) => _parseCustomDtoVariable(
                  valueTypeGeneric,
                  request,
                  e,
                ),
              )
              .toList();

          value = reflectClass(List).newInstance(
            #from,
            [value],
          ).reflectee;

          print(value);
        } else {
          value = _parseCustomDtoVariable(
            valueType,
            request,
            request.body[keyString],
          );
        }
      }

      arguments.addAll(
        {
          key: value,
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

  static _parseCustomDtoVariable(
    Type valueType,
    HttpRequest request,
    Map<String, dynamic> parentBody,
  ) {
    Map<Symbol, dynamic> dtoArguments = {};
    reflectClass(valueType)
        .declarations
        .entries
        .where((element) =>
            element.value.owner!.simpleName != element.value.simpleName)
        .forEach((element) {
      final symbol = element.key;
      final member = element.value;

      if (member is MethodMirror) {
        return;
      }

      final subKeyString = member.simpleName.toString().split('"')[1];
      var value = parentBody[subKeyString];

      final subValueType = (member as VariableMirror).type.reflectedType;
      if (!nativeAcceptedPropTypes.containsKey(subValueType)) {
        value = _parseCustomDtoVariable(
          subValueType,
          request,
          parentBody[subKeyString],
        );
      }

      dtoArguments.addAll(
        {
          symbol: value,
        },
      );
    });
    final value = reflectClass(valueType)
        .newInstance(
          reflectClass(valueType).owner!.simpleName,
          [],
          dtoArguments,
        )
        .reflectee;
    return value;
  }
}

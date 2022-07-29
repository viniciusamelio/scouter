import 'dart:mirrors';

import 'package:scouter/src/domain/route.dart';

abstract class MappedObject {
  Map<String, dynamic> toMap();
}

abstract class ResponseReflections {
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
    List<double>: true,
    List<num>: true,
    List<List>: true,
  };
  static HttpResponse getResponseFromObject(dynamic object) {
    final Map<String, dynamic> responseBody = {};

    final ref = reflect(object);

    if (ref.type.reflectedType == HttpResponse) {
      return object;
    } else if (ref.type.declarations.containsKey(#toMap)) {
      final Map<String, dynamic> responseBody =
          object.toMap() as Map<String, dynamic>;

      return _getResponse(responseBody);
    } else if (ref.type.declarations.containsKey(#toJson)) {
      final Map<String, dynamic> responseBody =
          object.toJson() as Map<String, dynamic>;

      return _getResponse(responseBody);
    }
    ref.type.declarations.forEach((_, member) {
      if (member.owner!.simpleName == member.simpleName ||
          (member is MethodMirror)) {
        return;
      }

      var value = ref.getField(_).reflectee;

      if (value is List) {
        value = _parseNonNativeTypeList(value);
      } else if (!nativeAcceptedPropTypes.containsKey(value.runtimeType)) {
        value = ResponseReflections.getResponseFromObject(value).body;
      }
      final key = member.simpleName.toString().split('"')[1];
      responseBody[key] = value;
    });
    return _getResponse(responseBody);
  }

  static HttpResponse _getResponse(Map<String, dynamic> responseBody) {
    final dynamic status = responseBody["httpStatus"] ?? 200;
    responseBody.remove("httpStatus");
    return HttpResponse(
      body: responseBody,
      status: status,
    );
  }

  static List _parseNonNativeTypeList(List value) {
    return value.map((e) {
      if (!nativeAcceptedPropTypes.containsKey(e.runtimeType)) {
        return ResponseReflections.getResponseFromObject(e).body;
      }
      return e;
    }).toList();
  }
}

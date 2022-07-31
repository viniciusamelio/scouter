import 'dart:mirrors';
import 'package:fpdart/fpdart.dart';
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

    final isParsingNeeded = _checkIfParsingIsNeeded(
      ref: ref,
      object: object,
    );

    if (isParsingNeeded.isRight()) {
      return isParsingNeeded.fold(
        (l) => HttpResponse(
          body: {},
        ),
        (r) => r,
      );
    }

    ref.type.declarations.forEach((symbol, member) {
      if (_isMethodOrConstructor(member)) {
        return;
      }

      var value = ref.getField(symbol).reflectee;
      value = _handleValueParsing(value);

      final key = member.simpleName.toString().split('"')[1];
      responseBody[key] = value;
    });
    return _getResponse(responseBody);
  }

  static HttpResponse _getResponse(Map<String, dynamic> responseBody) {
    dynamic status = responseBody["httpStatus"] ?? 200;
    status = _fixStatusIfNeeded(status);
    responseBody.remove("httpStatus");
    return HttpResponse(
      body: responseBody,
      status: status,
    );
  }

  static _fixStatusIfNeeded(dynamic status) {
    if (status is! int) {
      status = int.tryParse(status.toString());
      status ??= 200;
    }
    return status;
  }

  static List<Map<String, dynamic>> _parseNonNativeTypeList(List value) {
    return value.map<Map<String, dynamic>>((e) {
      if (!nativeAcceptedPropTypes.containsKey(e.runtimeType)) {
        return ResponseReflections.getResponseFromObject(e).body;
      }
      return e;
    }).toList();
  }

  static bool _isMethodOrConstructor(DeclarationMirror member) {
    if (member.owner!.simpleName == member.simpleName ||
        (member is MethodMirror)) {
      return true;
    }
    return false;
  }

  static _handleValueParsing(dynamic value) {
    if (value is List) {
      value = _parseNonNativeTypeList(value);
    } else if (!nativeAcceptedPropTypes.containsKey(value.runtimeType)) {
      value = ResponseReflections.getResponseFromObject(value).body;
    }
    return value;
  }

  static Either<void, HttpResponse> _checkIfParsingIsNeeded({
    required InstanceMirror ref,
    required dynamic object,
  }) {
    if (ref.type.reflectedType == HttpResponse) {
      return Right(object);
    } else if (ref.type.declarations.containsKey(#toMap)) {
      final Map<String, dynamic> responseBody =
          object.toMap() as Map<String, dynamic>;

      return Right(_getResponse(responseBody));
    } else if (ref.type.declarations.containsKey(#toJson)) {
      final Map<String, dynamic> responseBody =
          object.toJson() as Map<String, dynamic>;

      return Right(_getResponse(responseBody));
    } else if (object is Map) {
      final Map<String, dynamic> responseBody = object.map(
        (key, value) {
          if (!nativeAcceptedPropTypes.containsKey(value.runtimeType)) {
            value = ResponseReflections.getResponseFromObject(value).body;
          }
          return MapEntry(key.toString(), value);
        },
      );
      return Right(_getResponse(responseBody));
    }

    return Left(null);
  }
}

import 'dart:mirrors';

import 'package:scouter/src/domain/route.dart';

abstract class ResponseReflections {
  static HttpResponse getResponseFromObject(dynamic object) {
    final Map<String, dynamic> responseBody = {};
    final ref = reflect(object);

    if (ref.type.reflectedType == HttpResponse) {
      return object;
    }

    ref.type.declarations.forEach((_, member) {
      if (member.owner!.simpleName == member.simpleName) {
        return;
      }
      final value = ref.getField(_).reflectee;
      final key = member.simpleName.toString().split('"')[1];
      responseBody[key] = value;
    });
    final dynamic status = responseBody["status"];
    responseBody.remove("status");
    return HttpResponse(
      body: responseBody,
      status: status,
    );
  }
}

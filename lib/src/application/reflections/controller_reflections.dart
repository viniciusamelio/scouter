import 'dart:developer';
import 'dart:mirrors';

import '../../domain/http_controller.dart';
import '../../domain/http_verbs.dart';
import '../../domain/route.dart';

abstract class ControllerReflections {
  static List<HttpRoute> getControllerRoutes(dynamic clazz) {
    List<HttpRoute> routes = [];
    final ref = reflect(clazz);

    final clazzMetas = ref.type.metadata;
    if (clazzMetas.isEmpty) {
      throw ArgumentError.value(
          "Set @HttpController annotation to your controller class");
    }
    if (clazzMetas.first.type.reflectedType != HttpController) {
      throw ArgumentError.value(
          "Set @HttpController annotation to your controller class");
    }
    final controllerAnnotation = clazzMetas.first;

    ref.type.declarations.forEach((symbol, member) {
      if (!member.owner!.simpleName.toString().contains("Controller")) {
        throw Exception(
            "Your controller should contain 'Controller' in its class declaration");
      }

      final httpVerbAnnotations = member.metadata
          .where((meta) => meta.reflectee is HttpVerb)
          .map<HttpVerb>((meta) => meta.reflectee as HttpVerb)
          .toList();

      for (var i = 0; i < httpVerbAnnotations.length; i++) {
        final annotation = httpVerbAnnotations[i];
        final List<ParameterMirror> parameters = (member as dynamic).parameters;
        final List<MapEntry<Type, String>> declaredParams = parameters
            .map<MapEntry<Type, String>>(
              (e) => MapEntry(
                  e.type.reflectedType,
                  e.simpleName
                      .toString()
                      .replaceAll("Symbol(", "")
                      .replaceAll(")", "")
                      .replaceAll('"', "")),
            )
            .toList();
        final bool shouldUseHttpRequest = declaredParams
            .where((element) => element.key == HttpRequest)
            .isNotEmpty;
        // print(reflectedMethod.type.typeArguments);
        routes.add(
          HttpRoute(
            verb: annotation.verb,
            path: annotation.route,
            middlewares:
                (clazzMetas.first.reflectee as HttpController).middlewares,
            preffix:
                "/${controllerAnnotation.reflectee.name != "" ? controllerAnnotation.reflectee.name.toString().toLowerCase() : ref.reflectee.runtimeType.toString().replaceAll('Controller', '').toLowerCase()}",
            handler: (HttpRequest request) async {
              // Simpler case, when no request param is required and expected handler argument is a Http Request
              if (shouldUseHttpRequest && request.params!.isEmpty) {
                return ref.getField(member.simpleName).reflectee(request);
              }

              List<dynamic> listParams = [];
              // Add params according to given name, in the following format :name. To handler's arguments with same declared name
              if (request.params!.isNotEmpty) {
                listParams.addAll(
                  urlParams(
                    request,
                    declaredParams,
                  ),
                );
              }
              // TODO: Revisar isso aqui e fazer implementação de DTO como parâmetro do handler
              // TODO: Adicionar retorno automático com erro 500 para as requests
              listParams.addAll(
                declaredParams
                    .where(
                  (element) => !request.params!.containsKey(
                    element.value,
                  ),
                )
                    .map((e) {
                  if (e.key.toString() == "int") {
                    return int.parse(request.body[e.value]);
                  }
                  return request.body[e.value];
                }).toList(),
              );
              return ref.invoke(member.simpleName, listParams).reflectee;
            },
          ),
        );
      }
    });
    return routes;
  }

  static List urlParams(
      HttpRequest request, List<MapEntry<Type, String>> declaredParams) {
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
}

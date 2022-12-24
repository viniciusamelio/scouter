import 'dart:mirrors';

import '../../domain/http_controller.dart';
import '../../domain/http_verbs.dart';
import '../../domain/route.dart';
import 'request_parameter_reflections.dart';

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
        routes.add(
          HttpRoute(
            verb: annotation.verb,
            path: annotation.route,
            middlewares:
                (clazzMetas.first.reflectee as HttpController).middlewares,
            preffix:
                "/${controllerAnnotation.reflectee.name != "" ? controllerAnnotation.reflectee.name.toString().toLowerCase() : ref.reflectee.runtimeType.toString().replaceAll('Controller', '').toLowerCase()}",
            handler: (HttpRequest request) async {
              try {
                // Simpler case, when no request param is required and expected handler argument is a Http Request
                if (shouldUseHttpRequest && request.params!.isEmpty) {
                  return ref.getField(member.simpleName).reflectee(request);
                }

                List<dynamic> listParams = [];
                // Add params according to given name, in the following format :name. To handler's arguments with same declared name
                if (request.params!.isNotEmpty && declaredParams.isNotEmpty) {
                  listParams.addAll(
                    RequestParameterReflections.handleUrlParams(
                      request,
                      declaredParams,
                    ),
                  );
                }
                listParams.addAll(
                  declaredParams
                      .where(
                        // Ensuring parameter is not comming from url
                        (element) =>
                            !request.params!.containsKey(
                              element.value,
                            ) &&
                            // Ensuring parameter is annotated with @Body()
                            parameters
                                .firstWhere(
                                  (param) =>
                                      param.type.reflectedType == element.key,
                                )
                                .metadata
                                .where((metadata) => metadata.reflectee is Body)
                                .isNotEmpty,
                      )
                      .map(
                        (e) => RequestParameterReflections.handleBodyParams(
                          e,
                          request,
                          parameters,
                        ),
                      )
                      .toList(),
                );
                return ref.invoke(member.simpleName, listParams).reflectee;
              } catch (e) {
                return HttpResponse(
                  body: {
                    "message": "Something went wrong",
                    "error": e.toString(),
                  },
                  status: 500,
                );
              }
            },
          ),
        );
      }
    });
    return routes;
  }
}

class Body {
  const Body();
}

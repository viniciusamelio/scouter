import 'dart:async';
import 'dart:mirrors';

import '../../domain/http_controller.dart';
import '../../domain/http_verbs.dart';
import '../../domain/route.dart';

abstract class ControllerReflections {
  static List<HttpRoute> getControllerRoutes(dynamic clazz) {
    List<HttpRoute> routes = [];
    final ref = reflect(clazz);

    final clazzMetas = ref.type.metadata;
    if (clazzMetas.first.type.reflectedType != HttpController) {
      throw "Set @Controller annotation to your controller class";
    }
    final controllerAnnotation = clazzMetas.first;

    ref.type.declarations.forEach((_, member) {
      if (!member.owner!.simpleName.toString().contains("Controller")) {
        throw "Your controller should contain 'Controller' in its class declaration";
      }

      final httpVerbAnnotations = member.metadata
          .where((meta) => meta.reflectee is HttpVerb)
          .map<HttpVerb>((meta) => meta.reflectee as HttpVerb)
          .toList();

      for (var annotation in httpVerbAnnotations) {
        routes.add(
          HttpRoute(
            verb: annotation.verb,
            path: annotation.route,
            middlewares:
                (clazzMetas.first.reflectee as HttpController).middlewares,
            preffix:
                "/${controllerAnnotation.reflectee.name != "" ? controllerAnnotation.reflectee.name.toString().toLowerCase() : ref.reflectee.runtimeType.toString().replaceAll('Controller', '').toLowerCase()}",
            handler: (HttpRequest request) async {
              return ref.getField(member.simpleName).reflectee(request);
            },
          ),
        );
      }
    });
    return routes;
  }
}

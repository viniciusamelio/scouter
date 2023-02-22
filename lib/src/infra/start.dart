import 'package:alfred/alfred.dart';
import 'package:scouter/src/application/module/app_module.dart';
import 'package:scouter/src/domain/middleware.dart';
import 'package:scouter/src/application/reflections/controller_reflections.dart';
import 'package:scouter/src/infra/parser/alfred_route_parser.dart';

import '../domain/module.dart';

/// Starts a server with an AppModule. Default port and host are: 8080 and "0.0.0.0"
Future<void> runServer(
  AppModule appModule, {
  String? host,
  int? port,
}) async {
  final app = Alfred();
  app.typeHandlers.add(TypeHandler<HttpResponse>(((_, __, ___) => null)));

  if (appModule.init != null) appModule.init!();
  await _setupAppModule(appModule, app);
  await _setupChildModules(
    appModule.modules,
    app,
    appModule.globalMiddlewares,
  );
  app.listen(
    port ?? 8080,
    host ?? "0.0.0.0",
  );
}

Future<void> _setupAppModule(
  AppModule appModule,
  Alfred app,
) async {
  for (final controller in appModule.controllers) {
    for (var route in ControllerReflections.getControllerRoutes(controller)) {
      route.middlewares = [
        ...route.middlewares!.toList(),
        ...appModule.middlewares,
        ...appModule.globalMiddlewares,
      ];
      app.routes.add(
        AlfredRouteParser.parse(route),
      );
    }
  }
}

Future<void> _setupChildModules(
  List<Module> modules,
  Alfred app,
  List<HttpMiddleware> appMiddlewares,
) async {
  for (final module in modules) {
    if (module.init != null) {
      module.init!();
    }
    for (var controller in module.controllers) {
      for (var route in ControllerReflections.getControllerRoutes(controller)) {
        route.middlewares = [
          ...route.middlewares?.toList() ?? [],
          ...module.middlewares,
          ...appMiddlewares,
        ];
        if (module.preffix != null && module.preffix!.isNotEmpty) {
          route.preffix = "/${module.preffix!.replaceAll(
            '/',
            '',
          )}${controller.preffix?.replaceAll('/', '') != module.preffix!.replaceAll('/', '') ? "/${controller.preffix}" : ''}";
        }
        app.routes.add(
          AlfredRouteParser.parse(route),
        );
      }
    }
  }
}

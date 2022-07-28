import 'package:alfred/alfred.dart';
import 'package:scouter/src/application/module/app_module.dart';
import 'package:scouter/src/infra/core/controller_reflections.dart';
import 'package:scouter/src/infra/parser/alfred_route_parser.dart';

import '../domain/module.dart';

Future<void> runServer(
  AppModule appModule, {
  String? host,
  int? port,
}) async {
  final app = Alfred();
  app.typeHandlers.add(TypeHandler<HttpResponse>(((_, __, ___) => null)));

  await _setupAppModule(appModule, app);
  await _setupChildModules(appModule.modules, app);
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
      app.routes.add(
        AlfredRouteParser.parse(route),
      );
    }
  }
}

Future<void> _setupChildModules(
  List<Module> modules,
  Alfred app,
) async {
  for (final module in modules) {
    for (var controller in module.controllers) {
      for (var route in ControllerReflections.getControllerRoutes(controller)) {
        if (module.preffix.isNotEmpty) {
          route.preffix = "/${module.preffix.replaceAll(
            '/',
            '',
          )}${route.preffix}";
        }
        app.routes.add(
          AlfredRouteParser.parse(route),
        );
      }
    }
  }
}

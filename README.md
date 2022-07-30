Scouter is a package which was made following the goal to provide a NestJS-like experience to Dart Developers that want to develop Rest APIS

## Features

- Routing system through annotations
- Modules
- Middlewares
- DI

## Getting started

All you need to do is to add the package as a dependency, just like:
```dart
dart pub add scouter
```

## Usage

You can check a more complete example in example/scouter_example.dart
However, here you can find everything you need to start your application

### Initializing your app
You just need to call runServer() function inside main and make your setup, such as:

```dart
void main() async{
    final appModule = AppModule(
      modules: [
        TestModule(),
      ],
      middlewares: [
        ExampleMidleware(),
        LoggerMiddleware(),
      ],
      controllers: [
        FeatureController(),
        GameController(),
      ],
    );

    runServer(
        appModule,
        port: 8084,
    );
}
```

### App Module
Your app entrypoint and also main module, will be the AppModule class, which will receive your other Modules. Such as Middlewares, Controllers and Global Middlewares. <br>
Global Middlewares are, in a nutshell, middlewares which will be applied to every single route in your project, whatever the controller that will be wrapping it, or even the module itself.
The module preffix for endpoints declared in an app module's controller is "/". You can read more about it below.

### Modules
A module is designed to be a context wrapper of your application's business, it was made thinking about ease when talking about domain division. Each module will have their own controllers and middlewares. Scouter also requires a preffix, that will be responsible to mount the url. Usually, the url will follow this model: http://host/Module.preffix/Controller.name/Route.
Each module can also have their own middlewares. A module middleware will be applied to every route, inside every controller, declared in this middleware.

```dart
class TestModule extends Module {
  TestModule({super.preffix = "teste"});

  @override
  List<RestController> get controllers => [
        GameController(),
        ProfileController(),
      ];

  @override
  List<HttpMiddleware> get middlewares => [];
}
```

### Controllers
Each controller, just like a module, will have a preffix, but the thing about it is that you dont need to explicitly declare it if you dont want to. That's because Scouter can handle the classname itself to compose the preffix. You just need to ensure that your controller contains the word "Controller" on its name, it must be this way.
You also must extends RestController class. By default RestController will provide a way to inject and get injectables inside it, it will be clearer below, but for now, it is important to say that DI is made globally, so, you do not need to declare same DI Container twice.

```dart
@HttpController()
class ProfileController extends RestController {
  @Get("/private")
  getById(HttpRequest request) {
    return ResponseSample();
  }

  @Get("/")
  get(HttpRequest request) {
    return ResponseSample();
  }
}

class ResponseSample {
  String message = "Salvo com sucesso!";
  int savedId = 70;
  int httpStatus = 206;
}
```

Following the sample above, the endpoint declared on the "getById" method would be: http://host/somemodule/profile/private.
If you want to change the controller preffix, you can just do the following:

```dart
@HttpController(name: "pro")
class ProfileController extends RestController {
...
```

Which would result in the given url for same endpoint above:
http://host/somemodule/pro/private

### Routes
Now, talking about routes, you just need to give the desired http verb annotation to a Controller method. such as:

```dart
@HttpController()
class ProfileController extends RestController {
  @Get("/")
  get(HttpRequest request) {
    ...
  }

  @Post("/")
  get(HttpRequest request) {
    ...
  }
}
```
### Response parsing
Routes can have a return type of HttpResponse itself, but it also supports a Map or even a CustomClass. The best part of using a custom class is
that you will not need to parse it to a Map, Json or whatever. For example, if you try to return the following object from a route:
```dart
class Profile  {
  final String id = 1;
  final String name = "Anything";
  final List<String> tags = ["cool guy", "developer"];
  final String url = "https://pub.dev";
}
```
Scouter will parse it to the following format:
```json
{
  "id": 1,
  "name" : "Anything",
  "url": "https://pub.dev",
  "tags" : [
    "cool guy",
    "developer",
  ]
}
```
This method will not parse any method that your class may contain.<br>
Also, if you prefer, you can return a class which contains one of the following methods: toJson() or toMap(). Both should return a Map of String,dynamic.
Just like this:

```dart
class Profile  {
  final String id = 1;
  final String name = "Anything";
  final List<String> tags = ["cool guy", "developer"];
  final String url = "https://pub.dev";

  Map<String,dynamic> toMap() => {
    "name" : name,
    "tags" : tags,
    "url" : url,
  };
}
```

As you can see, you can ommit and apply whatever logic you want to compose your map, it is important that in the typing, the subtypes of entry, for the parsed map, to be declared, it may always be String and dynamic. <br>

By default, status 200 will be applied to response, but, if you are returning an object that will be parsed, just like above, you can set it through httpStatus property, which needs to be an int. It will be applied to the final response. Such as:

```dart
class Profile  {
  final String id = 1;
  final String name = "Anything";
  final List<String> tags = ["cool guy", "developer"];
  final String url = "https://pub.dev";
  final int httpStatus = 201;
}
```

It is important to notice that: 
- variables from custom objects will be parsed exactly how it is declared, soon, a way to customize the desired key will be introduced, but for now, if you declare something like this:
  ```dart
  class Profile  {
    final String idUser = 5;
  }
  ```
  It will be parsed to this:

  ```json
  {
    "idUser" : 5
  }
  ```
- if you are using the toMap() or toJson() methods, no processing will be made in your instance, instead, this methods will be called, just the way you implemented it
- no methods will be parsed, it includes getters.

You <b> Must </b> start the route with "/", otherwise an exception will be thrown when trying to run the server; <br>
You <b> Must </b> return something from your route, otherwise it will cause a timeout exception

## Middlewares
As said above, you can define middlewares to the whole application through your AppModule. Also, you can define it to a single module, including all of its children. The same as Controllers. <br>
A Middleware is nothing but a class which implements the HTTP Middleware interface. It just need to contains a handle(HttpRequest request) method, which MUST return a:
```dart
Future<Either<HttpResponse, void>> handle(HttpRequest request)
```
So, if you are not used to Either return, it is basically a way to have two return types, a Left and a Right.
Left would be a case when you dont want to proceed in your logic flow, and handle it as a exception, or something like this.
Right would be the opposite. <br>
So, knowing that, basically, you will want to return a HttpResponse if you do not want the request to going further in your api.
Otherwise, you can just return a Right() with a null, for example. <br>
It is importat to say that Scouter's uses FPDart package, which exports some functional programming stuff, thats where this Either comes from. If you want to, there is no need to add fpdart to your project, once Scouter does exports it too.
<br>
Example of middleware:

```dart
class ExampleMidleware implements HttpMiddleware {
  const ExampleMidleware();
  @override
  Future<Either<HttpResponse, void>> handle(HttpRequest request) async {
    if (request.path.contains("/game")) {
      return Left(
        HttpResponse(
          status: 400,
          body: {"status": "/game is not available"},
        ),
      );
    }
    return Right(null);
  }
}
```


Thats how you add middlewares to your module:

```dart
class TestModule extends Module {
  TestModule({super.preffix = "teste"});

  @override
  List<RestController> get controllers => [
        GameController(),
        ProfileController(),
      ];

  @override
  List<HttpMiddleware> get middlewares => [
    ExampleMidleware(),
  ];
}
```

And that is how you add middlewares to your controller:

```dart
@HttpController(
  middlewares: [
    ExampleMidleware(),
  ],
)
class GameController extends RestController {
  @Get("/")
  HttpResponse getById(HttpRequest request) {
    return HttpResponse(
      body: {"game": "Mario"},
      status: 202,
    );
  }
}
```

## DI

As saied above, RestControllers already have a DI system, which is provided through the Injectable mixin. You can apply it whatever you want to. <br>
Scouter's DI uses a Kiwi implementation, but the injection system is abstracted, soon, it will be possible to choose and implement the DI System you want to.
But for now, if you want to use Scouter's, you just need to the following:

```dart
@HttpController()
class FeatureController extends RestController {
  FeatureController() {
    inject<FakeProvider>(
      SingletonInjection(
        FakeProvider(),
      ),
    );
  }

  @Post("/save")
  HttpResponse save(HttpRequest request) {
    final FakeProvider teste = injected();
    return HttpResponse(
      body: {
        "teste": teste.name,
      },
    );
  }
}
```
So, inject will be responsible for saving your container, and will receive a injection, which can be a SingletonInjection or a FactoryInjection. So, inside <>() you just put the type you want to attribute to your container and voilà, the magic is done. <br>

And if you want to apply Scouter's DI to anywhere else in your project, you can just do the following:

```dart
import "package:scouter/scouter.dart";
class MyOwnClass with Injectable{
}
```

Through this, you will can use the inject and injected functions.


/// HttpVerb is a base for Methods Annotation, to handle Scouter Routing
abstract class HttpVerb {
  const HttpVerb(this.route, this.verb);

  /// Represents your endpoint route
  final String route;

  /// Represents your endpoint http method
  final String verb;
}

/// Add this annotation to a RestController public method to declare a GET route
class Get implements HttpVerb {
  const Get(this.route);

  @override
  final String route;

  @override
  final String verb = "get";
}

/// Add this annotation to a RestController public method to declare a POST route
class Post implements HttpVerb {
  const Post(this.route);

  @override
  final String route;

  @override
  final String verb = "post";
}

/// Add this annotation to a RestController public method to declare a PUT route
class Put implements HttpVerb {
  const Put(this.route);
  @override
  final String route;

  @override
  final String verb = "put";
}

/// Add this annotation to a RestController public method to declare a PATCH route
class Patch implements HttpVerb {
  const Patch(this.route);
  @override
  final String route;

  @override
  final String verb = "patch";
}

/// Add this annotation to a RestController public method to declare a DELETE route
class Delete implements HttpVerb {
  const Delete(this.route);
  @override
  final String route;

  @override
  final String verb = "delete";
}

/// Add this annotation to a RestController public method to declare a OPTIONS route
class Options implements HttpVerb {
  const Options(this.route);
  @override
  final String route;

  @override
  final String verb = "options";
}

/// Add this annotation to a RestController public method to declare a HEAD route
class Head implements HttpVerb {
  const Head(this.route);
  @override
  final String route;

  @override
  final String verb = "head";
}

abstract class HttpVerb {
  const HttpVerb(this.route, this.verb);
  final String route;
  final String verb;
}

class Get implements HttpVerb {
  const Get(this.route);

  @override
  final String route;

  @override
  final String verb = "get";
}

class Post implements HttpVerb {
  const Post(this.route);

  @override
  final String route;

  @override
  final String verb = "post";
}

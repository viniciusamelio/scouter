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

class Put implements HttpVerb {
  Put(this.route);
  @override
  final String route;

  @override
  final String verb = "put";
}

class Patch implements HttpVerb {
  Patch(this.route);
  @override
  final String route;

  @override
  final String verb = "patch";
}

class Delete implements HttpVerb {
  Delete(this.route);
  @override
  final String route;

  @override
  final String verb = "delete";
}

class Options implements HttpVerb {
  Options(this.route);
  @override
  final String route;

  @override
  final String verb = "options";
}

class Head implements HttpVerb {
  Head(this.route);
  @override
  final String route;

  @override
  final String verb = "head";
}

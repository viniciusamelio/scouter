import 'dart:io';

class AlfredHeadersParser {
  static Map<String, dynamic> parse(HttpRequest req) {
    final Map<String, dynamic> headers = {};
    req.headers.forEach(
      (name, values) {
        headers.addEntries({
          name: values.first.toString(),
        }.entries);
      },
    );

    return headers;
  }
}

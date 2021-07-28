import 'dart:convert';

import 'package:dune/schema/item.dart';

class ExtendedResponse {
  final response;
  final stopwatch;
  final Item parsedResponse;

  const ExtendedResponse(this.response, this.stopwatch, this.parsedResponse);

  int? get statusCode => parsedResponse.response?[0].code ?? 0;

  String get statusMessage => parsedResponse.response?[0].status ?? "";

  dynamic get body {
    var original = parsedResponse.response?[0].body ?? "";
    try {
      return JsonEncoder.withIndent(" " * 2)
          .convert(jsonDecode(jsonDecode(original)));
    } on Exception {
      return jsonDecode(original);
    }
  }

  dynamic get headers => parsedResponse.response?[0].header ?? {};
  dynamic get url => parsedResponse.request!.url!.raw;
  int get responseTime => parsedResponse.response![0].responseTime as int;

  dynamic contentSize() {
    return parsedResponse.response![0].body!.length / 1024;
  }
}

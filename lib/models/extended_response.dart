import 'dart:convert';

import 'package:dune/schema/item.dart';

const VALID_LANGS = ['json', 'html'];

class ExtendedResponse {
  final response;
  final stopwatch;
  final Item parsedResponse;

  const ExtendedResponse(this.response, this.stopwatch, this.parsedResponse);

  int? get statusCode => parsedResponse.response?[0].code ?? 0;

  String get statusMessage => parsedResponse.response?[0].status ?? "";

  String get language {
    var type = parsedResponse.response?[0].header
        ?.firstWhere((element) => element?.key == 'content-type');
    if (type != null) {
      for (var lang in VALID_LANGS) {
        if (type.value!.contains(lang)) {
          return lang;
        }
      }
    }
    return 'json';
  }

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

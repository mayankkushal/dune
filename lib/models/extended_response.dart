import 'package:dune/schema/Item.dart';

class ExtendedResponse {
  final response;
  final stopwatch;
  final Item parsedResponse;

  const ExtendedResponse(this.response, this.stopwatch, this.parsedResponse);

  int get statusCode => parsedResponse.response![0].code as int;

  String get statusMessage => parsedResponse.response![0].status as String;

  dynamic get body => parsedResponse.response![0].body as String;

  dynamic get headers => parsedResponse.response![0].header;
  dynamic get url => parsedResponse.request!.url!.raw;
  int get responseTime => parsedResponse.response![0].responseTime as int;

  dynamic contentSize() {
    return parsedResponse.response![0].body!.length / 1024;
  }
}

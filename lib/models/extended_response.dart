class ExtendedResponse {
  final response;
  final stopwatch;
  final parsedResponse;

  const ExtendedResponse(this.response, this.stopwatch, this.parsedResponse);

  int get statusCode => response.statusCode;

  String get statusMessage => response.statusMessage;

  dynamic get body => response.data;

  dynamic get headers => response.headers.map;

  dynamic contentSize() {
    return response.data.length / 1024;
  }
}

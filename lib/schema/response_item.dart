import 'package:dune/schema/request_item.dart';
import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class ResponseItem {
  ResponseItem({
    this.name,
    this.originalRequest,
    this.responseTime,
    this.status,
    this.code,
    this.header,
    this.cookie,
    this.body,
  });

  final String? name;
  final RequestItem? originalRequest;
  final int? responseTime;
  final String? status;
  final int? code;
  final List<HeaderPostman?>? header;
  final List<dynamic>? cookie;
  final String? body;

  ResponseItem copyWith({
    String? name,
    RequestItem? originalRequest,
    int? responseTime,
    String? status,
    int? code,
    List<HeaderPostman>? header,
    List<dynamic>? cookie,
    String? body,
  }) {
    return ResponseItem(
      name: name ?? this.name,
      originalRequest: originalRequest ?? this.originalRequest,
      responseTime: responseTime ?? this.responseTime,
      status: status ?? this.status,
      code: code ?? this.code,
      header: header ?? this.header,
      cookie: cookie ?? this.cookie,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'originalRequest': originalRequest?.toMap(),
      'responseTime': responseTime,
      'status': status,
      'code': code,
      'header': header?.map((x) => x?.toMap()).toList(),
      'cookie': cookie,
      'body': body,
      '_postman_previewlanguage': 'json',
    };
  }

  static ResponseItem? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return ResponseItem(
      name: map['name']?.toString(),
      originalRequest:
          RequestItem.fromMap(DartDynamic.asMap(map['originalRequest'])),
      responseTime: map['responseTime'],
      status: map['status']?.toString(),
      code: map['code'] == null ? null : int.tryParse(map['code'].toString()),
      header: DartDynamic.asList(map['header'])
          ?.map((x) => HeaderPostman.fromMap(DartDynamic.asMap(x)))
          .toList(),
      cookie: DartDynamic.asList(map['cookie']),
      body: map['body']?.toString(),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<ResponseItem?> fromJson(String source) async =>
      ResponseItem.fromMap(await TransformerJson.decode(source));

  @override
  String toString() {
    return 'Response(name: $name, originalRequest: $originalRequest, responseTime: $responseTime, $status, code: $code, header: $header, cookie: $cookie, body: $body)';
  }
}

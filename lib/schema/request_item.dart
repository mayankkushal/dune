import 'package:dio/dio.dart';
import 'package:dune/schema/url_item.dart';
import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class RequestItem {
  RequestItem({
    this.method,
    this.url,
    this.description,
    this.header,
    this.body,
    this.auth,
  });

  final String? method;
  final UrlItem? url;
  final String? description;
  final List<HeaderPostman?>? header;
  final BodyPostman? body;
  final AuthPostman? auth;

  RequestItem copyWith({
    String? method,
    UrlItem? url,
    String? description,
    List<HeaderPostman>? header,
    BodyPostman? body,
    AuthPostman? auth,
  }) {
    return RequestItem(
      method: method ?? this.method,
      url: url ?? this.url,
      description: description ?? this.description,
      header: header ?? this.header,
      body: body ?? this.body,
      auth: auth ?? this.auth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'url': url!.toMap(),
      'description': description,
      'header': header?.map((x) => x?.toMap()).toList(),
      'body': body?.toMap(),
      'auth': auth?.toMap(),
    };
  }

  static RequestItem? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return RequestItem(
      method: map['method']?.toString(),
      url: UrlItem.fromMap(DartDynamic.asMap(map['url'])),
      description: map['description']?.toString(),
      header: DartDynamic.asList(map['header'])
          ?.map((x) => HeaderPostman.fromMap(DartDynamic.asMap(x)))
          .where((element) => element != null)
          .toList(),
      body: BodyPostman.fromMap(DartDynamic.asMap(map['body'])),
      auth: AuthPostman.fromMap(DartDynamic.asMap(map['auth'])),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<RequestItem?> fromJson(String source) async =>
      RequestItem.fromMap(await TransformerJson.decode(source));

  @override
  String toString() {
    return 'Request(method: $method, url: $url, description: $description, header: $header, body: $body, auth: $auth)';
  }

  static Future<RequestItem?> fromRequest(RequestOptions? options) async {
    if (options == null) {
      return null;
    }
    return RequestItem(
      method: options.method,
      url: UrlItem.fromUri(options.safeUri!),
      body: BodyPostman(
          raw: options.data is FormData
              ? options.data?.toString()
              : await TransformerJson.encode(options.data)),
      header: options.headers.keys
          .map((key) => HeaderPostman(
                key: key,
                value: options.headers[key]?.toString(),
              ))
          .toList(),
    );
  }
}

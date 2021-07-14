import 'package:dune/schema/query_item.dart';
import 'package:postman_dio/helpers.dart';

class UrlItem {
  UrlItem({
    this.raw,
    this.query,
    this.protocol,
    this.host,
    this.port,
    this.path,
  });

  final String? raw;
  final List<QueryItem?>? query;
  final String? protocol;
  final List<String>? host;
  final int? port;
  final List<String>? path;

  String get cleaned => raw!.split('?')[0];

  UrlItem copyWith({
    String? raw,
    List<QueryItem>? query,
    String? protocol,
    List<String>? host,
    int? port,
    List<String>? path,
  }) {
    return UrlItem(
      raw: raw ?? this.raw,
      query: query ?? this.query,
      protocol: protocol ?? this.protocol,
      host: host ?? this.host,
      port: port ?? this.port,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'raw': raw,
      'query': query?.map((x) => x?.toMap()).toList(),
      'protocol': protocol,
      'host': host?.map((x) => x).toList(),
      'port': port,
      'path': path?.map((x) => x).toList(),
    };
  }

  static UrlItem? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return UrlItem(
      raw: map['raw']?.toString(),
      query: List<QueryItem>.from(DartDynamic.asList(map['query'])!
          .map((e) => QueryItem.fromMap(DartDynamic.asMap(e)))),
      protocol: map['protocol']?.toString(),
      host: List<String>.from(DartDynamic.asList(map['host'])!),
      path: List<String>.from(DartDynamic.asList(map['path'])!),
      port: map['port'] == null ? null : int.tryParse(map['port'].toString()),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<UrlItem?> fromJson(String source) async =>
      UrlItem.fromMap(await TransformerJson.decode(source));
  static UrlItem fromUri(Uri uri) {
    return UrlItem(
      host: uri.host.split('.'),
      path: uri.path.split('.'),
      protocol: uri.scheme,
      port: uri.port,
      query: uri.query
          .split('&')
          .map(QueryItem.fromString)
          .where((el) => el != null)
          .toList(),
      raw: uri.toString(),
    );
  }

  @override
  String toString() {
    return 'Url(raw: $raw, query: $query, protocol: $protocol, host: $host, port: $port, path: $path)';
  }
}

import 'package:postman_dio/helpers.dart';

class Info {
  Info({
    this.name,
    this.schema,
  });

  String? name;
  final String? schema;

  Info copyWith({
    String? name,
    String? schema,
  }) {
    return Info(
      name: name ?? this.name,
      schema: schema ?? this.schema,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'schema': schema,
    };
  }

  static Info? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return Info(
      name: map['name']?.toString(),
      schema: map['schema']?.toString(),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<Info?> fromJson(String source) async =>
      Info.fromMap(await TransformerJson.decode(source));

  @override
  String toString() => 'Info(name: $name, schema: $schema)';
}

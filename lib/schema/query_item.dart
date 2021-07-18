import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class QueryItem {
  QueryItem({this.key, this.value, this.disabled: false, this.description});

  final String? key;
  final String? value;
  final bool? disabled;
  final DescriptionPostman? description;

  QueryItem copyWith({
    String? key,
    String? value,
    bool? disabled,
    DescriptionPostman? description,
  }) {
    return QueryItem(
      key: key ?? this.key,
      value: value ?? this.value,
      disabled: disabled ?? this.disabled,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'disabled': disabled ?? false,
      'description': description?.toMap(),
    };
  }

  static QueryItem? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return QueryItem(
      key: map['key']?.toString(),
      value: map['value']?.toString(),
      disabled: DartDynamic.asBool(map['disabled']) ?? false,
      description:
          DescriptionPostman.fromMap(DartDynamic.asMap(map['description'])),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<QueryItem?> fromJson(String source) async =>
      QueryItem.fromMap(await TransformerJson.decode(source));

  @override
  String toString() {
    return 'Query(key: $key, value: $value, disabled: $disabled, description: $description)';
  }

  static QueryItem? fromString(String? e) {
    if (e == null) {
      return null;
    }
    final split = e.split('=');
    if (split.length == 2) {
      return QueryItem(key: split[0], value: split[1]);
    }
    return null;
  }
}

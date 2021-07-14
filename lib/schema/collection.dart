import 'package:dune/schema/Item.dart';
import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class Collection {
  Collection({
    this.item,
    this.info,
  });
  final InfoCollection? info;
  final List<Item?>? item;

  Collection copyWith({
    InfoCollection? info,
    List<Item>? item,
  }) {
    return Collection(
      info: info ?? this.info,
      item: item ?? this.item,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'info': info?.toMap(),
      'item': item?.map((x) => x?.toMap()).toList(),
    };
  }

  static Collection? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return Collection(
      info: InfoCollection.fromMap(DartDynamic.asMap(map['info'])),
      item: DartDynamic.asList(map['item'])
          ?.map((x) => Item.fromMap(DartDynamic.asMap<String, dynamic>(x)))
          .toList(),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<Collection?> fromJson(String source) async =>
      Collection.fromMap(await TransformerJson.decode(source));

  @override
  String toString() => 'Postman(info: $info, item: $item)';
}

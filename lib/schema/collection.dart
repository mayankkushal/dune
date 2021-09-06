import 'package:dune/schema/folder.dart';
import 'package:dune/schema/item.dart';
import 'package:postman_dio/helpers.dart';

import 'info.dart';

class Collection {
  Collection({
    this.info,
    this.item,
  });

  final Info? info;
  List<dynamic>? item;

  Collection copyWith({
    Info? info,
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
      info: Info.fromMap(DartDynamic.asMap(map['info'])),
      item: DartDynamic.asList(map['item'])
          ?.map((x) => x.containsKey('item')
              ? Folder.fromMap(DartDynamic.asMap<String, dynamic>(x))
              : Item.fromMap(DartDynamic.asMap<String, dynamic>(x)))
          .toList(),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<Collection?> fromJson(String source) async =>
      Collection.fromMap(await TransformerJson.decode(source));

  @override
  String toString() => 'Dune(info: $info, item: $item)';
}

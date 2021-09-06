import 'package:dune/schema/request_item.dart';
import 'package:dune/schema/response_item.dart';
import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class Item {
  Item({
    this.name,
    this.request,
    this.protocolProfileBehavior,
    this.response,
  });

  String? name;
  RequestItem? request;
  ProtocolProfileBehavior? protocolProfileBehavior;
  List<ResponseItem>? response;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'request': request?.toMap(),
      'protocolProfileBehavior': protocolProfileBehavior?.toMap(),
      'response': response?.map((x) => x.toMap()).toList(),
    };
  }

  static Item? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    Item item = Item(
      name: map['name']?.toString(),
      request: RequestItem.fromMap(DartDynamic.asMap(map['request'])),
      protocolProfileBehavior: ProtocolProfileBehavior.fromMap(
          DartDynamic.asMap(map['protocolProfileBehavior'])),
    );

    if (map['response'] != null) {
      item.response = List<ResponseItem>.from(
        DartDynamic.asList(map['response'])!
            .map((e) => ResponseItem.fromMap(DartDynamic.asMap(e))),
      );
    }

    return item;
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<Item?> fromJson(String source) async =>
      Item.fromMap(await TransformerJson.decode(source));

  @override
  String toString() {
    return 'Item(name: $name, request: $request, protocolProfileBehavior: $protocolProfileBehavior, response: $response)';
  }
}

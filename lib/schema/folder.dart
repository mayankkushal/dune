import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'item.dart';

class Folder {
  String? name;
  String? description;
  List<Item>? item;
  Folder({
    this.name,
    this.description,
    this.item,
  });

  Folder copyWith({
    String? name,
    String? description,
    List<Item>? item,
  }) {
    return Folder(
      name: name ?? this.name,
      description: description ?? this.description,
      item: item ?? this.item,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'item': item?.map((x) => x.toMap()).toList(),
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      name: map['name'],
      description: map['description'],
      item: List<Item>.from(map['item']?.map((x) => Item.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Folder.fromJson(String source) => Folder.fromMap(json.decode(source));

  @override
  String toString() =>
      'Folder(name: $name, description: $description, item: $item)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Folder &&
        other.name == name &&
        other.description == description &&
        listEquals(other.item, item);
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ item.hashCode;
}

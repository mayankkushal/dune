import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dune/models/environment_item.dart';
import 'package:get_storage/get_storage.dart';

import '../constants.dart';

class Environment {
  String name;
  bool disabled;
  bool isGlobal;
  List<EnvironmentItem> items;
  String uid;

  Environment({
    required this.name,
    this.disabled: true,
    this.isGlobal: false,
    required this.items,
    required this.uid,
  });

  Environment copyWith({
    String? name,
    bool? disabled,
    bool? isGlobal,
    List<EnvironmentItem>? items,
    String? uid,
  }) {
    return Environment(
      name: name ?? this.name,
      disabled: disabled ?? this.disabled,
      isGlobal: isGlobal ?? this.isGlobal,
      items: items ?? this.items,
      uid: uid ?? this.uid,
    );
  }

  Future<void> save() async {
    var storage = GetStorage();
    if (isGlobal) {
      await storage.write(GLOBAL_VARIABLES, toMap());
    } else {
      var envList = storage.read(ENV_LIST);
      int itemIndex = envList.indexWhere((env) => env["uid"] == uid);
      if (itemIndex == -1) {
        envList.add(toMap());
      } else {
        envList[itemIndex] = toMap();
      }
      storage.write(ENV_LIST, envList);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'disabled': disabled,
      'isGlobal': isGlobal,
      'items': items.map((x) => x.toMap()).toList(),
      'uid': uid,
    };
  }

  factory Environment.fromMap(Map<String, dynamic> map) {
    return Environment(
      name: map['name'],
      disabled: map['disabled'],
      isGlobal: map['isGlobal'],
      items: List<EnvironmentItem>.from(
          map['items']?.map((x) => EnvironmentItem.fromMap(x))),
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Environment.fromJson(String source) =>
      Environment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Environment(name: $name, disabled: $disabled, isGlobal: $isGlobal, items: $items, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Environment &&
        other.name == name &&
        other.disabled == disabled &&
        other.isGlobal == isGlobal &&
        listEquals(other.items, items) &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        disabled.hashCode ^
        isGlobal.hashCode ^
        items.hashCode ^
        uid.hashCode;
  }
}

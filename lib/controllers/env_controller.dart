import 'package:dune/models/environment.dart';
import 'package:dune/models/environment_item.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class EnvController with ChangeNotifier {
  late Environment environment;
  bool dirty = false;

  // controllers
  late TextEditingController nameInputController;

  EnvController(Environment? data) {
    if (data != null) {
      environment = data;
    } else {
      environment =
          Environment(uid: Uuid().v4(), name: "Environment Name", items: []);
    }
  }

  void checkDirty() {
    var storage = GetStorage();
    if (environment.isGlobal) {
      var globalVariables = storage.read(GLOBAL_VARIABLES);
      dirty = globalVariables.toString() != environment.toMap().toString();
    } else {
      var envList = storage.read(ENV_LIST);
      dynamic item = envList.firstWhere(
        (env) => env["uid"] == environment.uid,
        orElse: () => null,
      );
      if (item != null) {
        dirty = item.toString() != environment.toMap().toString();
      } else {
        dirty = true;
      }
    }
  }

  void afterUpdate() {
    checkDirty();
    notifyListeners();
  }

  void addInput() {
    environment.items.add(EnvironmentItem());
    afterUpdate();
  }

  void removeInput(EnvironmentItem item) {
    environment.items.remove(item);
    afterUpdate();
  }

  void updateName(dynamic value) {
    environment.name = value;
    afterUpdate();
  }

  void updateDisabled(EnvironmentItem item, dynamic value) {
    item.disabled = value;
    afterUpdate();
  }

  void updateKey(EnvironmentItem item, dynamic value) {
    item.key = value;
    afterUpdate();
  }

  void updateInitialValue(EnvironmentItem item, dynamic value) {
    item.initialValue = value;
    afterUpdate();
  }

  void updateCurrentValue(EnvironmentItem item, dynamic value) {
    item.currentValue = value;
    afterUpdate();
  }

  Future<void> save(Environment item) async {
    item.save();
    afterUpdate();
  }
}

import 'package:dune/models/environment.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class MainEnvController extends GetxController {
  late Environment global;
  final envs = [].obs;
  final reload = false.obs;

  @override
  onInit() {
    var storage = GetStorage();
    var globalVariables = storage.read(GLOBAL_VARIABLES);
    if (globalVariables == null) {
      global = Environment(
          uid: Uuid().v4(), name: "Globals", isGlobal: true, items: []);
      storage.write(GLOBAL_VARIABLES, global.toMap());
      storage.write(ENV_LIST, []);
    } else {
      global = Environment.fromMap(globalVariables);
      var envList = storage.read(ENV_LIST);
      if (envList != null) {
        envList.forEach((env) => envs.add(Environment.fromMap(env)));
      }
    }
    super.onInit();
  }

  @override
  void onClose() {
    var storage = GetStorage();
    storage.write(GLOBAL_VARIABLES, global.toMap());
    super.onClose();
  }

  void createEnvironment() {
    var env = Environment(
        uid: Uuid().v4(), name: "Environment ${envs.length + 1}", items: []);
    envs.add(env);
    update();
  }

  void deleteEnvironment(Environment item) {
    envs.remove(item);
    update();
  }

  void markActive(Environment item) {
    envs.forEach((env) {
      env.disabled = true;
      env.save();
    });
    item.disabled = false;
    item.save();
    update();
  }

  static MainEnvController get to => Get.find();
}

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class EnvController extends GetxController {
  final global = {}.obs;
  final envs = [].obs;

  @override
  onInit() {
    var storage = GetStorage();
    var globalVariables = storage.read('globalVariables');
    if (globalVariables == null) {
      storage.write('globalVariables', {});
    } else {
      global.value = globalVariables;
    }
    super.onInit();
  }

  static EnvController get to => Get.find();
}

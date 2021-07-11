import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  final history = {}.obs;

  // HistoryController(dynamic initial) {
  //   history.value = initial;
  // }

  @override
  onInit() {
    history.value = GetStorage().read('history');
    super.onInit();
  }

  static HistoryController get to => Get.find();

  void addHistory(object) async {
    // var storageHistory = GetStorage().read('history');
    // print(storageHistory);
    var now = new DateTime.now();
    history[now.microsecondsSinceEpoch.toString()] = object;
    GetStorage().write('history', history);
    // print(history);
  }
}

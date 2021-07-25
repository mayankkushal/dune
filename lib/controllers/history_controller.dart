import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  final history = {}.obs;

  @override
  onInit() {
    super.onInit();
    var storageHistrory = GetStorage().read('history');
    if (storageHistrory != null) {
      history.value = GetStorage().read('history');
    }
  }

  static HistoryController get to => Get.find();

  void addHistory(object, item) async {
    var now = new DateTime.now();
    history[now.microsecondsSinceEpoch.toString()] = object;
    GetStorage().write('history', history);
  }
}

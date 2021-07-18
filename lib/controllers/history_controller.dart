import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  final history = {}.obs;

  @override
  onInit() {
    history.value = GetStorage().read('history');
    super.onInit();
  }

  static HistoryController get to => Get.find();

  void addHistory(object, item) async {
    var now = new DateTime.now();
    history[now.microsecondsSinceEpoch.toString()] = object;
    GetStorage().write('history', history);
  }
}

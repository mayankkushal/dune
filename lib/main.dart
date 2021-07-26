import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: find handeling for this, which is supported in web
  // try {
  //   if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //     setWindowFrame(Rect.fromLTWH(100.0, 200.0, 1300.0, 700.0));
  //   }
  // } on Exception catch (e) {
  //   print("Skipping frame size on web");
  // }
  await GetStorage.init();
  runApp(App());
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:window_size/window_size.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowFrame(Rect.fromLTWH(100.0, 200.0, 1300.0, 700.0));
  }
  await GetStorage.init();
  runApp(App());
}

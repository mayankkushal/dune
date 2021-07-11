import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import './routes.dart';
import 'controllers/history_controller.dart';
import 'theme.dart';

class App extends StatelessWidget {
  final data = GetStorage();
  HistoryController historyController = Get.put(HistoryController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dune',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      getPages: routes,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
    );
  }
}

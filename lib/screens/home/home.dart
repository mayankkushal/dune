import 'package:dune/controllers/env_controller.dart';
import 'package:dune/widgets/main_tab_bar/tab_bar.dart';
import 'package:dune/widgets/side_bar.dart';
import 'package:dune/widgets/split.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/main_tab_controller.dart';

class Home extends StatefulHookWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = GetStorage();

  MainTabController tabController = Get.put(MainTabController());
  EnvController envController = Get.put(EnvController());

  @override
  Widget build(BuildContext context) {
    // print(storage.read('history'));
    // storage.erase();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Split(
          initialFractions: [0.3, 0.7],
          minSizes: [250.0, 850.0],
          children: [
            SideBar(),
            Column(
              children: [
                Flexible(
                    flex: 7, child: MainTabBar(tabController: tabController)),
                Obx(
                  () => Flexible(
                    flex: 93,
                    fit: FlexFit.tight,
                    child: PageView.builder(
                      controller: tabController.pageController,
                      itemCount: tabController.pages.length,
                      onPageChanged: (index) =>
                          tabController.currentPage.value = index,
                      itemBuilder: (context, position) {
                        return tabController.pages[position].page;
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

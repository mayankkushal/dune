import 'package:dune/controllers/main_collection_controller.dart';
import 'package:dune/controllers/main_env_controller.dart';
import 'package:dune/theme.dart';
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
  MainEnvController envController = Get.put(MainEnvController());
  MainCollectionController _ = Get.put(MainCollectionController());

  @override
  Widget build(BuildContext context) {
    // print(storage.read('history'));
    // storage.erase();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () => {}, icon: Icon(Icons.settings))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Split(
                initialFractions: [0.3, 0.7],
                minSizes: [250.0, 850.0],
                children: [
                  SideBar(),
                  Column(
                    children: [
                      Flexible(
                          flex: 7,
                          child: MainTabBar(tabController: tabController)),
                      Obx(
                        () => Flexible(
                          flex: 93,
                          fit: FlexFit.tight,
                          child: PageView.builder(
                            controller: tabController.pageController,
                            itemCount: tabController.pages.length,
                            onPageChanged: (index) {
                              tabController.currentPage.value = index;
                              tabController.update();
                            },
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
          ],
        ),
      ),
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: AppColors.secondaryBackground,
      elevation: 5,
      child: Container(
        height: 50,
        child: Row(
          children: [Text("Settings")],
        ),
      ),
    );
  }
}

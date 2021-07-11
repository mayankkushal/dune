import 'package:dune/widgets/main_tab_bar/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_tab_controller.dart';

class Home extends StatelessWidget {
  MainTabController tabController = Get.put(MainTabController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            Flexible(flex: 7, child: MainTabBar(tabController: tabController)),
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
      ),
    );
  }
}

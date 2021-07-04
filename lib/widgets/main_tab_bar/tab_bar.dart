import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_tab_controller.dart';
import 'tab_bar_item.dart';

class MainTabBar extends StatelessWidget {
  const MainTabBar({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final MainTabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tabController.pages.length + 1,
          itemBuilder: (context, index) {
            if (index == tabController.pages.length)
              return IconButton(
                  onPressed: tabController.addPage, icon: Icon(Icons.add));
            return itemBuilder(context, index);
          },
        ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return MainTabItem(position: index, tabController: tabController);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_tab_controller.dart';
import '../../theme.dart';

class MainTabItem extends StatelessWidget {
  const MainTabItem(
      {Key? key, required this.tabController, required this.position})
      : super(key: key);

  final MainTabController tabController;
  final int position;

  bool get isCurrent => tabController.currentPage.value == position;
  String get tabMethod => tabController.pages[position].responseController
      .methodDropDownController.value['name'];
  String get tabName =>
      tabController.pages[position].responseController.nameInputController.text;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          constraints: BoxConstraints(minWidth: 75),
          decoration: BoxDecoration(
              color:
                  AppColors.secondaryBackground.withOpacity(isCurrent ? 0 : 1),
              border: isCurrent
                  ? Border(
                      top: BorderSide(color: AppColors.yellow, width: 3),
                      left: BorderSide(color: Colors.white),
                      right: BorderSide(color: Colors.white),
                      bottom: BorderSide.none)
                  : Border(bottom: BorderSide(color: Colors.white))),
          child: InkWell(
            onTap: () => tabController.changePage(position),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("$tabMethod $tabName"),
                  InkWell(
                    child: Icon(Icons.close_sharp, size: 15),
                    onTap: () => tabController.removePage(position),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

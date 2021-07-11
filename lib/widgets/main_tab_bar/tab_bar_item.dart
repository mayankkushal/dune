import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_tab_controller.dart';
import '../../theme.dart';

const MAX_TAB_TEXT_LENGTH = 16;

class MainTabItem extends StatelessWidget {
  const MainTabItem(
      {Key? key, required this.tabController, required this.position})
      : super(key: key);

  final MainTabController tabController;
  final int position;

  bool get isCurrent => tabController.currentPage.value == position;
  String get tabMethod => tabController.pages[position].method;
  String get tabName => tabController.pages[position].name;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          constraints: BoxConstraints(minWidth: 75, maxWidth: 180),
          decoration: BoxDecoration(
              color:
                  AppColors.secondaryBackground.withOpacity(isCurrent ? 0 : 1),
              border: isCurrent
                  ? Border(
                      top: BorderSide(color: AppColors.yellow, width: 3),
                      left: BorderSide(color: Colors.white),
                      right: BorderSide(color: Colors.white))
                  : Border(bottom: BorderSide(color: Colors.white))),
          child: InkWell(
            onTap: () => tabController.changePage(position),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$tabMethod $tabName".length > MAX_TAB_TEXT_LENGTH
                        ? '${"$tabMethod $tabName".substring(0, MAX_TAB_TEXT_LENGTH)}...'
                        : "$tabMethod $tabName",
                  ),
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

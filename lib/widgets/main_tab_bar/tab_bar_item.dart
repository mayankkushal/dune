import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../../controllers/main_tab_controller.dart';
import '../../theme.dart';

const MAX_TAB_TEXT_LENGTH = 16;
const TAB_RADIUS = 10.0;

class MainTabItem extends HookWidget {
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
    final showCloseButton = useState(false);
    return GetBuilder<MainTabController>(
      builder: (_) => ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TAB_RADIUS)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 180),
          decoration: isCurrent
              ? ShapeDecoration(
                  shape: CustomRoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(TAB_RADIUS),
                      topRight: Radius.circular(TAB_RADIUS)),
                  leftSide: BorderSide(color: AppColors.yellow),
                  topLeftCornerSide: BorderSide(color: AppColors.yellow),
                  topRightCornerSide: BorderSide(color: AppColors.yellow),
                  rightSide: BorderSide(color: AppColors.yellow),
                  topSide: BorderSide(color: AppColors.yellow),
                ))
              : BoxDecoration(
                  color: AppColors.secondaryBackground.withOpacity(1),
                  border: Border(bottom: BorderSide(color: Colors.white))),
          child: InkWell(
            onTap: () {
              tabController.changePage(position);
            },
            onHover: (hovering) {
              showCloseButton.value = hovering;
            },
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
                  (isCurrent || showCloseButton.value)
                      ? InkWell(
                          child: Icon(Icons.close_sharp, size: 15),
                          hoverColor: AppColors.yellow,
                          onTap: () => tabController.removePage(position),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';

import '../../controllers/main_tab_controller.dart';
import 'tab_bar_item.dart';

class MainTabBar extends HookWidget {
  const MainTabBar({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final MainTabController tabController;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    void _onReorder(int oldIndex, int newIndex) {
      var page = tabController.pages[oldIndex];
      tabController.pages[oldIndex] = tabController.pages[newIndex];
      tabController.pages[newIndex] = page;
    }

    return Container(
      child: Obx(
        () => ScrollConfiguration(
          behavior: DragScrollBehavior(),
          child: ListView.builder(
            // onReorder: _onReorder,
            // buildDefaultDragHandles: false,
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            itemCount: tabController.pages.length + 1,
            itemBuilder: (context, index) {
              if (index == tabController.pages.length)
                return ReorderableWidget(
                  key: UniqueKey(),
                  reorderable: false,
                  child: IconButton(
                      onPressed: () {
                        tabController.addRequestPage(null);
                        Timer(
                            Duration(milliseconds: 125),
                            () => scrollController.jumpTo(
                                scrollController.position.maxScrollExtent));
                      },
                      icon: Icon(Icons.add)),
                );
              return itemBuilder(context, index);
            },
          ),
        ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return MainTabItem(position: index, tabController: tabController);
  }
}

class DragScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postwoman/screens/request_container/request_container.dart';
import 'package:postwoman/theme.dart';

class TabController extends GetxController {
  final tabs = [].obs;
  final pages = [].obs;
  final currentPage = 0.obs;

  final PageController pageController = PageController();

  void addPage() {
    tabs.add(
      MainTabItem(
        tabController: this,
        position: pages.length,
      ),
    );
    var requestContainer = RequestContainer();
    pages.add(requestContainer);
    pageController.jumpToPage(pages.length - 1);
    currentPage.value = pages.length - 1;
  }

  void removePage(int position) {
    tabs.removeAt(position);
    pages.removeAt(position);
    currentPage.value = pages.length - 1;
    pageController.jumpToPage(pages.length - 1);
  }

  void changePage(int position) {
    pageController.jumpToPage(position);
    currentPage.value = position;
  }
}

class MainTabItem extends StatelessWidget {
  const MainTabItem(
      {Key? key, required this.tabController, required this.position})
      : super(key: key);

  final TabController tabController;
  final int position;

  bool isCurrent() => tabController.currentPage.value == position;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          constraints: BoxConstraints(minWidth: 75),
          decoration: BoxDecoration(
            color:
                AppColors.secondaryBackground.withOpacity(isCurrent() ? 0 : 1),
            border: isCurrent()
                ? Border(
                    top: BorderSide(color: AppColors.yellow, width: 3),
                    left: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.white),
                    bottom: BorderSide.none)
                : Border(bottom: BorderSide(color: Colors.white)),
          ),
          child: InkWell(
            onTap: () => tabController.changePage(position),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tab $position'),
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

class Home extends StatelessWidget {
  TabController tabController = Get.put(TabController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            Obx(() => Container(
                  child: Row(
                    children: [
                      ...tabController.tabs,
                      IconButton(
                          onPressed: () => tabController.addPage(),
                          icon: Icon(Icons.add))
                    ],
                  ),
                )),
            Obx(
              () => Expanded(
                child: PageView.builder(
                  controller: tabController.pageController,
                  itemCount: tabController.pages.length,
                  onPageChanged: (index) =>
                      tabController.currentPage.value = index,
                  itemBuilder: (context, position) {
                    return tabController.pages[position];
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

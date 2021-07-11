import 'package:dune/controllers/history_controller.dart';
import 'package:dune/widgets/main_tab_bar/tab_bar.dart';
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
  HistoryController historyController = HistoryController.to;

  // @override
  // void initState() {
  //   super.initState();
  //   historyController =
  // }

  @override
  Widget build(BuildContext context) {
    // print(storage.read('history'));
    // storage.erase();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Split(
          initialFractions: [0.2, 0.8],
          minSizes: [100.0, 850.0],
          children: [
            Column(
              children: [
                Text('History'),
                Expanded(
                  child: Obx(
                    () => historyController.history.value != null
                        ? ListView.builder(
                            controller: ScrollController(),
                            itemCount: historyController.history.keys.length,
                            itemBuilder: (context, index) => Text(
                                DateTime.fromMicrosecondsSinceEpoch(int.parse(
                                        historyController.history.keys
                                            .elementAt(historyController
                                                    .history.keys.length -
                                                1 -
                                                index)))
                                    .toString()),
                            physics: ClampingScrollPhysics(),
                          )
                        : Text('Lets make some History'),
                  ),
                ),
              ],
            ),
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

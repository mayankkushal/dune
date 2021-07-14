import 'dart:convert';

import 'package:dune/controllers/history_controller.dart';
import 'package:dune/schema/Item.dart';
import 'package:dune/widgets/main_tab_bar/tab_bar.dart';
import 'package:dune/widgets/split.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../controllers/main_tab_controller.dart';

class Home extends StatefulHookWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = GetStorage();

  MainTabController tabController = Get.put(MainTabController());

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
            HistorySection(),
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

class HistorySection extends StatelessWidget {
  HistoryController historyController = HistoryController.to;
  MainTabController tabController = MainTabController.to;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          child: Text('History'),
        ),
        Expanded(
          child: Obx(
            () => historyController.history.keys.length > 0
                ? ListView.builder(
                    controller: ScrollController(),
                    itemCount: historyController.history.keys.length,
                    itemBuilder: itemBuilder,
                    physics: ClampingScrollPhysics(),
                  )
                : Text('Lets create History together'),
          ),
        ),
      ],
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    String key = historyController.history.keys
        .elementAt(historyController.history.keys.length - 1 - index);
    var data = jsonDecode(historyController.history[key]);
    Item? item = Item.fromMap(data);
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(int.parse(key));
    String finalDate = DateFormat("dd-MM-yyyy").format(date);
    String time = DateFormat.Hms().format(date);
    String method = 'None';
    if (item!.request!.method != null) {
      method = item.request!.method as String;
    }
    return ClipRect(
      child: InkWell(
        onTap: () => tabController.addPage(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(method),
              ),
              Text("$finalDate - $time")
            ],
          ),
        ),
      ),
    );
  }
}

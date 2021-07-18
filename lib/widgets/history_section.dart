import 'dart:convert';

import 'package:dune/controllers/history_controller.dart';
import 'package:dune/controllers/main_tab_controller.dart';
import 'package:dune/schema/item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Text('History', style: Theme.of(context).textTheme.headline5),
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

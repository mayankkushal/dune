import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:postwoman/screens/home/input_pane/input_pane.dart';
import 'package:postwoman/widgets/circle_decoration.dart';

import '../../../../theme.dart';
import 'body_container.dart';
import 'header_container.dart';

class ResponseTabBarContainer extends StatelessWidget {
  const ResponseTabBarContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
          alignment: TabBarAlignment.start,
          padding: EdgeInsets.only(bottom: 3),
          indicator: CircleTabIndicator(color: AppColors.yellow, radius: 4.0),
          labelColor: AppColors.yellow,
          unselectedLabelColor: Colors.white,
          background: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white)),
            ),
          ),
        ),
        tabBarViewProperties: TabBarViewProperties(
          physics: NeverScrollableScrollPhysics(),
        ),
        tabs: [
          TabBarItem("Body"),
          TabBarItem("Headers"),
          TabBarItem("Cookies"),
          TabBarItem("Details"),
        ],
        views: [
          const BodyContainer(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: HeaderContainer(),
          ),
          Container(color: Colors.blue),
          Container(color: Colors.green),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}

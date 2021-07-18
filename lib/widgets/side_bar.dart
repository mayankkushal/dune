import 'package:dune/controllers/env_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../theme.dart';
import 'history_section.dart';

const HISTORY_POS = 0;
const ENV_POS = 1;

class SideBar extends HookWidget {
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final activePage = useState(0);

    void changeTab(int pos) {
      _controller.animateToPage(pos,
          duration: Duration(milliseconds: 250), curve: Curves.easeIn);
      activePage.value = pos;
    }

    return Row(children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        decoration: BoxDecoration(
            color: AppColors.sideBarColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(offset: Offset(1.5, 0), blurRadius: 3)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Tooltip(
                  waitDuration: Duration(seconds: 1),
                  message: 'History',
                  child: IconButton(
                      onPressed: () => changeTab(HISTORY_POS),
                      icon: Icon(
                        Icons.history,
                        color: activePage.value == HISTORY_POS
                            ? AppColors.yellow
                            : Colors.white,
                      )),
                ),
                Tooltip(
                  waitDuration: Duration(seconds: 1),
                  message: 'Environment',
                  child: IconButton(
                      onPressed: () => changeTab(ENV_POS),
                      icon: activePage.value == ENV_POS
                          ? Icon(
                              Icons.eco,
                              color: AppColors.yellow,
                            )
                          : Icon(Icons.eco_outlined)),
                )
              ],
            ),
            FlutterLogo(
              size: 35,
            )
          ],
        ),
      ),
      Expanded(
        child: PageView(
          controller: _controller,
          children: [HistorySection(), EvironmentSection()],
        ),
      ),
    ]);
  }
}

class EvironmentSection extends StatelessWidget {
  EnvController envController = EnvController.to;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Text('Environment'),
        ),
        InkWell(
          onTap: () => print('clicked'),
          child: Text('Global'),
        ),
        Expanded(
          child: Obx(() => envController.envs.length > 0
              ? ListView.builder(
                  controller: ScrollController(),
                  itemCount: envController.envs.length,
                  itemBuilder: itemBuilder,
                  physics: ClampingScrollPhysics(),
                )
              : Text('Lets create History together')),
        ),
      ],
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Text('test');
  }
}

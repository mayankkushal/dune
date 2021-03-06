import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../theme.dart';
import 'env_section.dart';
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
          onPageChanged: (index) => activePage.value = index,
          children: [HistorySection(), EvironmentSection()],
        ),
      ),
    ]);
  }
}

class SidebarTitle extends StatelessWidget {
  const SidebarTitle(this.title, {Key? key}) : super(key: key);
  final title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Text(title, style: Theme.of(context).textTheme.headline5),
    );
  }
}

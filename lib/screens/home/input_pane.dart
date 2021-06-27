import 'dart:async';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:postwoman/models/circle_decoration.dart';
import 'package:postwoman/theme.dart';
import 'package:provider/provider.dart';

class InputPane extends HookWidget {
  final GlobalKey<FormState> _parameterFormKey;

  const InputPane({
    Key? key,
    required GlobalKey<FormState> parameterFormKey,
  })  : _parameterFormKey = parameterFormKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _parameterFormKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ContainedTabBarView(
            tabBarProperties: TabBarProperties(
              padding: EdgeInsets.only(bottom: 3),
              indicator:
                  CircleTabIndicator(color: AppColors.yellow, radius: 4.0),
              labelColor: AppColors.yellow,
              unselectedLabelColor: Colors.white,
              background: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(7)),
              ),
            ),
            tabBarViewProperties: TabBarViewProperties(
              physics: NeverScrollableScrollPhysics(),
            ),
            tabs: [
              TabBarItem("Query Params"),
              TabBarItem("Auth"),
              TabBarItem("Headers"),
              TabBarItem("Pre-request Script"),
            ],
            views: [
              QueryParameterInput(),
              Container(color: Colors.blue),
              HeaderInput(),
              Container(color: Colors.green),
            ],
            onChange: (index) => print(index),
          ),
        ),
      ),
    );
  }
}

class TabBarItem extends StatelessWidget {
  const TabBarItem(
    this.text, {
    Key? key,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Text(text));
  }
}

class QueryParameterInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    ReponseController parameterInputController =
        Provider.of<ReponseController>(context);

    return Column(children: [
      Flexible(
        flex: 9,
        fit: FlexFit.tight,
        child: ListView(
          controller: scrollController,
          children: [...parameterInputController.queryParamMap.keys],
        ),
      ),
      Flexible(
        child: IconButton(
          onPressed: () {
            parameterInputController.addParameter(ParameterInputType.query);
            Timer(
                Duration(milliseconds: 125),
                () => scrollController
                    .jumpTo(scrollController.position.maxScrollExtent));
          },
          icon: Icon(Icons.add),
        ),
      )
    ]);
  }
}

class HeaderInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    ReponseController responseController =
        Provider.of<ReponseController>(context);

    return Column(children: [
      Flexible(
        flex: 9,
        fit: FlexFit.tight,
        child: ListView(
          controller: scrollController,
          children: [...responseController.headersMap.keys],
        ),
      ),
      Flexible(
        child: IconButton(
          onPressed: () {
            responseController.addParameter(ParameterInputType.header);
            Timer(
                Duration(milliseconds: 125),
                () => scrollController
                    .jumpTo(scrollController.position.maxScrollExtent));
          },
          icon: Icon(Icons.add),
        ),
      )
    ]);
  }
}

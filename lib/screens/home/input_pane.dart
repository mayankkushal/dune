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
    ReponseController responseController =
        Provider.of<ReponseController>(context);
    return Form(
      key: _parameterFormKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ContainedTabBarView(
            tabBarProperties: TabBarProperties(
              // isScrollable: true,
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
              TabBarItem("Params"),
              TabBarItem("Auth"),
              TabBarItem("Headers"),
              TabBarItem("Body"),
              TabBarItem("Scripts"),
            ],
            views: [
              QueryParameterInput(),
              Container(color: Colors.blue),
              HeaderInput(),
              BodyInput(),
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
    return Flexible(
      child: Container(
          height: double.infinity,
          width: 100,
          alignment: Alignment.center,
          child: Text(text)),
    );
  }
}

class QueryParameterInput extends HookWidget {
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
          children: [...responseController.queryParamMap.keys],
        ),
      ),
      Flexible(
        child: IconButton(
          onPressed: () {
            responseController.addParameter(ParameterInputType.query);
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

class BodyInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    ReponseController responseController =
        Provider.of<ReponseController>(context);

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        alignment: Alignment.centerLeft,
        child: DropdownButton<String>(
          value: responseController.bodyType,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          onChanged: (String? newValue) {
            responseController.updateBodyType(newValue);
          },
          items: <String>['application/json', "form-data"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
      Flexible(
        flex: 8,
        fit: FlexFit.tight,
        child: ListView(
          controller: scrollController,
          children: [...responseController.bodyMap.keys],
        ),
      ),
      Flexible(
        child: IconButton(
          onPressed: () {
            responseController.addParameter(ParameterInputType.body);
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

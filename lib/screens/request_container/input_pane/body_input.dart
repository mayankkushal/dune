import 'dart:async';

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:provider/provider.dart';

import '../../../theme.dart';

class BodyInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    ReponseController responseController =
        Provider.of<ReponseController>(context);

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DropdownButton<String>(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlutterSwitch(
                height: 15,
                width: 30,
                toggleSize: 12.5,
                value: responseController.useRawBody,
                showOnOff: false,
                onToggle: (val) {
                  responseController.updateRawBody(val);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Raw Input'),
              )
            ],
          ),
        ],
      ),
      if (responseController.useRawBody)
        CodeField(
            controller: responseController.rawBodyController,
            lineNumberStyle:
                LineNumberStyle(width: 60, textAlign: TextAlign.center),
            background: AppColors.background)
      else
        Expanded(
          child: Column(children: [
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
            ),
          ]),
        )
    ]);
  }
}

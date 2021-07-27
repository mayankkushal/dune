import 'dart:async';

import 'package:dune/controllers/response_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class QueryParameterInput extends StatefulHookWidget {
  @override
  _QueryParameterInputState createState() => _QueryParameterInputState();
}

class _QueryParameterInputState extends State<QueryParameterInput> {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final responseController = context.watch<ResponseController>();

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

import 'dart:async';

import 'package:dune/controllers/request_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class HeaderInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    RequestController responseController =
        Provider.of<RequestController>(context);

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

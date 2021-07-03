import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:provider/provider.dart';

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

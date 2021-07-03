import 'package:flutter/material.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:postwoman/screens/home/response_pane/response/response_section.dart';
import 'package:postwoman/screens/home/response_pane/status_section.dart';
import 'package:provider/provider.dart';

import 'loader.dart';

class ResponsePane extends StatelessWidget {
  const ResponsePane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReponseController responseController =
        Provider.of<ReponseController>(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StatusSection(),
                Spacer(
                  flex: 1,
                ),
                ResponseSection(),
              ],
            ),
            responseController.isLoading ? ResponseLoader() : Container(),
          ],
        ),
      ),
    );
  }
}

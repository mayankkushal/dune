import 'package:dune/controllers/response_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loader.dart';
import 'response/response_section.dart';
import 'status_section.dart';

class ResponsePane extends StatelessWidget {
  const ResponsePane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select((ReponseController p) => p.isLoading);
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
            isLoading ? ResponseLoader() : Container(),
          ],
        ),
      ),
    );
  }
}

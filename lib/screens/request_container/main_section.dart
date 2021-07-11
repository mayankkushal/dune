import 'package:dune/widgets/split.dart';
import 'package:flutter/material.dart';

import 'input_pane/input_pane.dart';
import 'response_pane/response_pane.dart';

class MainSection extends StatelessWidget {
  const MainSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Split(
        initialFractions: [0.4, 0.6],
        minSizes: [335.0, 400.0],
        children: [
          InputPane(),
          ResponsePane(),
        ],
      ),
    );
  }
}

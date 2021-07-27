import 'package:flutter/material.dart';

import 'main_section.dart';
import 'url_section.dart';

class RequestContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: UrlSection(),
          ),
          MainSection()
        ],
      ),
    );
  }
}

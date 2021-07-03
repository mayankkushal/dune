import 'package:flutter/material.dart';

import 'main_section.dart';
import 'url_section.dart';

class RequestContainer extends StatelessWidget {
  const RequestContainer({
    Key? key,
    required GlobalKey<FormState> parameterFormKey,
  })  : _parameterFormKey = parameterFormKey,
        super(key: key);

  final GlobalKey<FormState> _parameterFormKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: UrlSection(),
          ),
          MainSection(parameterFormKey: _parameterFormKey)
        ],
      ),
    );
  }
}

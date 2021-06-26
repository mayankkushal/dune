import 'package:flutter/material.dart';
import 'package:postwoman/screens/home/input_pane.dart';
import 'package:postwoman/screens/home/response_pane.dart';

class MainSection extends StatelessWidget {
  const MainSection(
      {Key? key,
      required GlobalKey<FormState> parameterFormKey,
      required this.response})
      : _parameterFormKey = parameterFormKey,
        super(key: key);

  final GlobalKey<FormState> _parameterFormKey;
  final response;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: InputPane(parameterFormKey: _parameterFormKey),
          ),
          Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: ResponsePane(response: response)),
        ],
      ),
    );
  }
}

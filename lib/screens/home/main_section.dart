import 'package:flutter/material.dart';
import 'package:postwoman/screens/home/input_pane.dart';
import 'package:postwoman/screens/home/response_pane.dart';

class MainSection extends StatelessWidget {
  const MainSection(
      {Key? key,
      required GlobalKey<FormState> parameterFormKey,
      required this.parameterList,
      required this.response,
      required this.onPressed})
      : _parameterFormKey = parameterFormKey,
        super(key: key);

  final GlobalKey<FormState> _parameterFormKey;
  final ValueNotifier<List> parameterList;
  final response;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputPane(
              parameterFormKey: _parameterFormKey,
              parameterList: parameterList,
              onPressed: onPressed),
          ResponsePane(response: response),
        ],
      ),
    );
  }
}

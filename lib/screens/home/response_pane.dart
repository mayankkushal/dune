import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:postwoman/widgets/json_viewer.dart';

class ResponsePane extends StatelessWidget {
  const ResponsePane({
    Key? key,
    required this.response,
  }) : super(key: key);

  final response;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatusSection(response: response),
            Spacer(
              flex: 1,
            ),
            ResponseSection(response: response),
          ],
        ),
      ),
    );
  }
}

class ResponseSection extends StatelessWidget {
  const ResponseSection({
    Key? key,
    required this.response,
  }) : super(key: key);

  final response;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 90,
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: SingleChildScrollView(
            child: JsonViewer(response.value != null
                ? json.decode(response.value!.body)
                : null),
          ),
        ),
      ),
    );
  }
}

class StatusSection extends StatelessWidget {
  const StatusSection({
    Key? key,
    required this.response,
  }) : super(key: key);

  final response;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 9,
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (response.value != null)
                Text("Status: ${response.value!.statusCode}")
              else
                Container(),
            ],
          ),
        ),
      ),
    );
  }
}

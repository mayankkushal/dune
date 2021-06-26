import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glass/glass.dart';
import 'package:postwoman/controllers/ResponseController.dart';
import 'package:postwoman/theme.dart';
import 'package:postwoman/widgets/json_viewer.dart';
import 'package:provider/provider.dart';

class ResponsePane extends StatelessWidget {
  const ResponsePane({
    Key? key,
    required this.response,
  }) : super(key: key);

  final response;
  @override
  Widget build(BuildContext context) {
    ReponseController parameterInputController =
        Provider.of<ReponseController>(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StatusSection(response: response),
                Spacer(
                  flex: 1,
                ),
                ResponseSection(response: response),
              ],
            ),
            parameterInputController.isLoading ? ResponseLoader() : Container(),
          ],
        ),
      ),
    );
  }
}

class ResponseLoader extends StatelessWidget {
  const ResponseLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitChasingDots(
              color: AppColors.yellow,
              size: 50.0,
            ),
            Text("Fetching Response")
          ],
        ),
      ).asGlass(clipBorderRadius: BorderRadius.circular(10)),
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
          child: response.value != null
              ? SingleChildScrollView(
                  child: JsonViewer(json.decode(response.value!.response.body)),
                )
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/response_background.png'),
                        fit: BoxFit.cover),
                  ),
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

  String getSize(int length) {
    return (length / 1024).toStringAsFixed(2);
  }

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
          child: (response.value != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text("Status: ${response.value!.response.statusCode}"),
                      Text(
                          "Time Elapsed: ${response.value!.stopwatch.elapsed.inMilliseconds}ms"),
                      Text(
                          "Size: ${getSize(response.value!.response.contentLength)}KB")
                    ])
              : Text('Response'),
        ),
      ),
    );
  }
}

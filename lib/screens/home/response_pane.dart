import 'dart:convert';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glass/glass.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:postwoman/models/circle_decoration.dart';
import 'package:postwoman/screens/home/input_pane.dart';
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
        child: response.value != null
            ? ResponseTabBarContainer(response: response)
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/response_background.png'),
                      fit: BoxFit.cover),
                ),
              ),
      ),
    );
  }
}

class ResponseTabBarContainer extends StatelessWidget {
  const ResponseTabBarContainer({
    Key? key,
    required this.response,
  }) : super(key: key);

  final response;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
          alignment: TabBarAlignment.start,
          padding: EdgeInsets.only(bottom: 3),
          indicator: CircleTabIndicator(color: AppColors.yellow, radius: 4.0),
          labelColor: AppColors.yellow,
          unselectedLabelColor: Colors.white,
          background: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white)),
            ),
          ),
        ),
        tabBarViewProperties: TabBarViewProperties(
          physics: NeverScrollableScrollPhysics(),
        ),
        tabs: [
          TabBarItem("Body"),
          TabBarItem("Headers"),
          TabBarItem("Cookies"),
          TabBarItem("Details"),
        ],
        views: [
          BodyContainer(response: response),
          Padding(
            padding: const EdgeInsets.all(8),
            child: HeaderContainer(response: response),
          ),
          Container(color: Colors.blue),
          Container(color: Colors.green),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}

class BodyContainer extends StatelessWidget {
  const BodyContainer({
    Key? key,
    required this.response,
  }) : super(key: key);

  final response;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: JsonViewer(json.decode(response.value!.response.body)),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({Key? key, required this.response}) : super(key: key);

  final response;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Table(border: TableBorder.all(color: Colors.white), children: [
          ...response.value.response.headers.entries
              .map((header) => TableRow(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(header.key),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(header.value),
                        ),
                      ),
                    ],
                  ))
              .toList()
        ]),
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
                      Text(
                          "Status: ${response.value!.response.statusCode} ${response.value!.response.reasonPhrase}"),
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

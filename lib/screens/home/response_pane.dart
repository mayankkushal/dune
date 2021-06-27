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
  const ResponseSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReponseController responseController =
        Provider.of<ReponseController>(context);
    return Flexible(
      flex: 90,
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(7)),
        child: responseController.response != null
            ? ResponseTabBarContainer()
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
  const ResponseTabBarContainer({Key? key}) : super(key: key);

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
          BodyContainer(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: HeaderContainer(),
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
  const BodyContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReponseController responseController =
        Provider.of<ReponseController>(context);
    return SingleChildScrollView(
      child:
          JsonViewer(json.decode(responseController.response!.response.body)),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ReponseController responseController =
        Provider.of<ReponseController>(context);
    return Container(
      child: SingleChildScrollView(
        child: Table(border: TableBorder.all(color: Colors.white), children: [
          ...responseController.response!.response.headers.entries
              .map((header) => TableRow(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(header.key),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(header.value),
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
  const StatusSection({Key? key}) : super(key: key);

  String getSize(int length) {
    return (length / 1024).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    ReponseController responseController =
        Provider.of<ReponseController>(context);
    return Flexible(
      flex: 9,
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (responseController.response != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(
                          "Status: ${responseController.response!.response.statusCode} ${responseController.response!.response.reasonPhrase}"),
                      Text(
                          "Time Elapsed: ${responseController.response!.stopwatch.elapsed.inMilliseconds}ms"),
                      Text(
                          "Size: ${getSize(responseController.response!.response.contentLength)}KB")
                    ])
              : Text('Response'),
        ),
      ),
    );
  }
}

import 'package:dune/controllers/request_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RequestController responseController =
        Provider.of<RequestController>(context);
    return Container(
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Table(border: TableBorder.all(color: Colors.white), children: [
          ...responseController.response!.headers
              .map((header) => TableRow(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(header.key),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
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

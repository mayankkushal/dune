import 'package:dune/controllers/response_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ReponseController responseController =
        Provider.of<ReponseController>(context);
    return Container(
      child: SingleChildScrollView(
        child: Table(border: TableBorder.all(color: Colors.white), children: [
          ...responseController.response!.headers.entries
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(header.value[0]),
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

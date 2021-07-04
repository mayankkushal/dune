import 'package:flutter/material.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:provider/provider.dart';

import 'main_section.dart';
import 'url_section.dart';

class RequestContainer extends StatefulWidget {
  const RequestContainer({
    Key? key,
  }) : super(key: key);

  @override
  _RequestContainerState createState() => _RequestContainerState();
}

class _RequestContainerState extends State<RequestContainer> {
  GlobalKey<FormState> _parameterFormKey = GlobalKey<FormState>();
  ReponseController reponseController = ReponseController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: reponseController,
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: UrlSection(),
            ),
            MainSection(parameterFormKey: _parameterFormKey)
          ],
        ),
      ),
    );
  }
}

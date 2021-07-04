import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:provider/provider.dart';

import 'main_section.dart';
import 'url_section.dart';

class RequestContainer extends StatefulHookWidget {
  late ReponseController? responseController;

  @override
  _RequestContainerState createState() {
    var state = _RequestContainerState();
    responseController = state.reponseController;
    return state;
  }
}

class _RequestContainerState extends State<RequestContainer>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<FormState> _parameterFormKey = GlobalKey<FormState>();
  ReponseController reponseController = ReponseController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

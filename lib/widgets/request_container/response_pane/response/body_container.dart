import 'package:dune/controllers/response_controller.dart';
import 'package:dune/response_body_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../selectable_highlight_view.dart';

class BodyContainer extends StatefulWidget {
  const BodyContainer({Key? key}) : super(key: key);

  @override
  _BodyContainerState createState() => _BodyContainerState();
}

class _BodyContainerState extends State<BodyContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final response = context.select((ResponseController p) => p.response);
    super.build(context);
    return RepaintBoundary(
      child: SelectableHighlightView(
        response!.body,
        language: 'json',
        padding: EdgeInsets.all(12),
        theme: duneDarkTheme,
      ),
    );
  }
}

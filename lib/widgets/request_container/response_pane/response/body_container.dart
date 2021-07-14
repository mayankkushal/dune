import 'dart:convert';

import 'package:code_text_field/code_text_field.dart';
import 'package:dune/controllers/response_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/json.dart';
import 'package:provider/provider.dart';

import '../../../../theme.dart';

class BodyContainer extends StatefulWidget {
  const BodyContainer({Key? key}) : super(key: key);

  @override
  _BodyContainerState createState() => _BodyContainerState();
}

class _BodyContainerState extends State<BodyContainer>
    with AutomaticKeepAliveClientMixin {
  CodeController? _codeController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Instantiate the CodeController
    _codeController = CodeController(
      text: "",
      language: json,
      theme: monokaiSublimeTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final response = context.select((ResponseController p) => p.response);
    _codeController!.text = jsonDecode(response!.body);
    super.build(context);
    return RepaintBoundary(
      child: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: CodeField(
              controller: _codeController!,
              lineNumberStyle:
                  LineNumberStyle(width: 60, textAlign: TextAlign.center),
              background: AppColors.background),
        ),
      ),
    );
  }
}

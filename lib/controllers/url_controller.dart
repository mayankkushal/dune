import 'package:code_text_field/code_text_field.dart';
import 'package:dune/extensions/string_apis.dart';
import 'package:dune/response_body_theme.dart';
import 'package:dune/schema/item.dart';
import 'package:dune/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

import '../constants.dart';

class UrlController with ChangeNotifier {
  late CodeController urlInputController;
  late TextEditingController nameInputController;
  late DropdownEditingController<Map<String, dynamic>>
      methodDropDownController = DropdownEditingController(value: METHODS[0]);

  UrlController(Item? data) {
    if (data != null) {
      loadData(data);
    } else {
      methodDropDownController = DropdownEditingController(value: METHODS[0]);
      nameInputController = TextEditingController(text: "Request Name");
      urlInputController = CodeController(
        text: "",
        patternMap: {
          ENV_REGEX: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.purpleAccent),
        },
        theme: duneDarkTheme,
      );
    }
  }
  void loadData(Item data) {
    methodDropDownController = DropdownEditingController(
        value: {'name': data.request?.method ?? METHODS[0]['name']});
    nameInputController = TextEditingController(text: data.name);
    urlInputController = CodeController(
      text: data.request?.url?.cleaned ?? "",
      patternMap: {
        ENV_REGEX:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent),
      },
      theme: monokaiSublimeTheme,
    );
  }
}

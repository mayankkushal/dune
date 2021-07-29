import 'package:dune/schema/item.dart';
import 'package:dune/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class UrlController with ChangeNotifier {
  late TextEditingController urlInputController = TextEditingController();
  TextEditingController nameInputController =
      TextEditingController(text: "Request Name");
  late DropdownEditingController<Map<String, dynamic>>
      methodDropDownController = DropdownEditingController(value: METHODS[0]);

  UrlController(Item? data) {
    if (data != null) {
      loadData(data);
    } else {
      methodDropDownController = DropdownEditingController(value: METHODS[0]);
      urlInputController = TextEditingController();
    }
  }
  void loadData(Item data) {
    methodDropDownController =
        DropdownEditingController(value: {'name': data.request!.method});
    urlInputController =
        TextEditingController(text: data.request!.url!.cleaned);
  }
}

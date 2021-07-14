import 'dart:convert' as convert;

import 'package:code_text_field/code_text_field.dart';
import 'package:dio/dio.dart';
import 'package:dune/constants.dart';
import 'package:dune/controllers/history_controller.dart';
import 'package:dune/controllers/request_logger.dart';
import 'package:dune/models/extended_response.dart';
import 'package:dune/schema/Item.dart';
import 'package:dune/widgets/dropdown.dart';
import 'package:dune/widgets/request_container/parameter_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/json.dart';

enum ParameterInputType { query, header, body }
const INITIAL_INPUT_COUNT = 4;

class ResponseController with ChangeNotifier {
  Map<Widget, Map<dynamic, dynamic>> queryParamMap = {};
  Map<Widget, Map<dynamic, dynamic>> headersMap = {};
  Map<Widget, Map<dynamic, dynamic>> bodyMap = {};

  String? bodyType = "application/json";
  bool useRawBody = false;

  bool isLoading = false;

  ExtendedResponse? response;
  Item? parsedResponse;
  var dio = Dio();

  // Controllers
  // Controller to handle method types
  late DropdownEditingController<Map<String, dynamic>> methodDropDownController;

  // Controller to handle url input
  late TextEditingController urlInputController;
  // Controller to handle request name
  TextEditingController nameInputController =
      TextEditingController(text: "Request Name");
  // Controller to handle raw body input
  late CodeController rawBodyController;

  ResponseController(Item? data) {
    if (data != null) {
      loadPageData(data);
    } else {
      initializeFreshPage();
    }
    dio.interceptors.add(
      RequestLogger(
          onAddHistory: (object, item) {
            parsedResponse = item;
            HistoryController.to.addHistory(object, item);
          },
          addHistory: true),
    );
    print(parsedResponse);
  }

  void loadPageData(Item data) {
    methodDropDownController =
        DropdownEditingController(value: {'name': data.request!.method});
    loadUrl(data);
    loadInputParam(ParameterInputType.query, data.request!.url!.query);
    loadInputParam(ParameterInputType.header, data.request!.header);
    loadBody(data);
  }

  void loadUrl(Item data) {
    urlInputController =
        TextEditingController(text: data.request!.url!.cleaned);
  }

  void loadBody(Item data) {
    useRawBody = true;
    rawBodyController = CodeController(
      text: data.request!.body!.raw,
      language: json,
      theme: monokaiSublimeTheme,
    );
  }

  void initializeFreshPage() {
    methodDropDownController = DropdownEditingController(value: METHODS[0]);
    urlInputController = TextEditingController();
    addParameter(ParameterInputType.query, count: INITIAL_INPUT_COUNT);
    addParameter(ParameterInputType.header, count: INITIAL_INPUT_COUNT);
    addParameter(ParameterInputType.body, count: INITIAL_INPUT_COUNT);
    rawBodyController = CodeController(
      text: "{ \n\t\n}",
      language: json,
      theme: monokaiSublimeTheme,
    );
  }

  void loadInputParam(ParameterInputType type, dynamic data) {
    if (data.length > 0) {
      data.forEach((input) => addParameter(type, data: input.toMap()));
    }
    addParameter(type, count: INITIAL_INPUT_COUNT - data.length);
  }

  Map initialData = {
    ParameterInputType.query: {'disabled': true, 'key': "", 'value': ""},
    ParameterInputType.header: {'disabled': true, 'key': "", 'value': ""},
    ParameterInputType.body: {'disabled': true, 'key': "", 'value': ""}
  };

  void removeParameterInput(
      Map<Widget, Map<dynamic, dynamic>> parameterMap, Widget input) {
    parameterMap.remove(input);
    notifyListeners();
  }

  void addParameterInput(ParameterInputType type,
      Map<Widget, Map<dynamic, dynamic>> parameterMap, dynamic initial) {
    parameterMap[new ParameterInput(type, key: UniqueKey())] =
        Map.from(initial);
    notifyListeners();
  }

  Map<Widget, Map<dynamic, dynamic>> getParameterMap(ParameterInputType type) {
    switch (type) {
      case ParameterInputType.query:
        return queryParamMap;
      case ParameterInputType.header:
        return headersMap;
      case ParameterInputType.body:
        return bodyMap;
    }
  }

  void addParameter(ParameterInputType type, {count: 1, data}) {
    if (data == null) {
      data = initialData[type];
    }
    for (var i = 0; i < count; i++) {
      addParameterInput(type, getParameterMap(type), data);
    }
  }

  void removeParameter(ParameterInputType type, Widget input) {
    removeParameterInput(getParameterMap(type), input);
  }

  void updateValue(
      ParameterInputType type, Widget input, String key, dynamic value) {
    getParameterMap(type)[input]![key] = value;
    notifyListeners();
  }

  dynamic getValue(ParameterInputType type, Widget input, String key) {
    return getParameterMap(type)[input]![key];
  }

  void updateBodyType(String? value) {
    bodyType = value;
    notifyListeners();
  }

  void updateRawBody(bool value) {
    useRawBody = value;
    notifyListeners();
  }

  void loading() {
    isLoading = true;
    notifyListeners();
  }

  void ready() {
    isLoading = false;
    notifyListeners();
  }

  Map<String, dynamic> getParameterInputAsMap(ParameterInputType type) {
    var finalQuery = <String, String>{};
    for (var qp in getParameterMap(type).values) {
      if (qp['disabled'] == false) {
        finalQuery[qp['key']] = qp['value'];
      }
    }
    return finalQuery;
  }

  Map<String, dynamic> getBody() {
    if (useRawBody) {
      return convert.json.decode(rawBodyController.text);
    }
    return getParameterInputAsMap(ParameterInputType.body);
  }

  void fetchRequest() async {
    loading();
    final stopwatch = Stopwatch()..start();
    late var res;
    try {
      res = await dio.request(
        urlInputController.text,
        queryParameters: getParameterInputAsMap(ParameterInputType.query),
        data: getBody(),
        options: Options(
            method: methodDropDownController.value!['name'],
            headers: getParameterInputAsMap(ParameterInputType.header),
            responseType: ResponseType.plain),
      );
    } on DioError catch (e) {
      res = e.response;
    }
    stopwatch..stop();
    // final exportedCollection = await PostmanDioLogger.export();
    // print(exportedCollection);
    response = ExtendedResponse(res, stopwatch, parsedResponse);
    ready();
  }
}

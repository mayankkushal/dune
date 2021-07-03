import 'dart:convert' as convert;

import 'package:code_text_field/code_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/json.dart';
import 'package:postwoman/constants.dart';
import 'package:postwoman/models/extended_response.dart';
import 'package:postwoman/screens/request_container/parameter_input.dart';
import 'package:postwoman/widgets/dropdown.dart';

enum ParameterInputType { query, header, body }

class ReponseController with ChangeNotifier {
  Map<Widget, Map<dynamic, dynamic>> queryParamMap = {};
  Map<Widget, Map<dynamic, dynamic>> headersMap = {};
  Map<Widget, Map<dynamic, dynamic>> bodyMap = {};

  String? bodyType = "application/json";
  bool useRawBody = false;

  bool isLoading = false;

  ExtendedResponse? response;
  var dio = Dio();

  // Controllers

  // Controller to handle method types
  DropdownEditingController<Map<String, dynamic>> methodDropDownController =
      DropdownEditingController(value: METHODS[0]);
  // Controller to handle url input
  TextEditingController urlInputController = TextEditingController();
  // Controller to handel raw body input
  CodeController rawBodyController = CodeController(
    text: "{ \n\t\n}",
    language: json,
    theme: monokaiSublimeTheme,
  );

  ReponseController() {
    addParameter(ParameterInputType.query, count: 4);
    addParameter(ParameterInputType.header, count: 4);
    addParameter(ParameterInputType.body, count: 4);
  }

  Map initialData = {
    ParameterInputType.query: {'isActive': false, 'key': "", 'value': ""},
    ParameterInputType.header: {'isActive': false, 'key': "", 'value': ""},
    ParameterInputType.body: {'isActive': false, 'key': "", 'value': ""}
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

  void addParameter(ParameterInputType type, {count: 1}) {
    for (var i = 0; i < count; i++) {
      addParameterInput(type, getParameterMap(type), initialData[type]);
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
    // return true;
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
      if (qp['isActive'] == true) {
        finalQuery[qp['key']] = qp['value'];
      }
    }
    return finalQuery;
  }

  Map<String, dynamic> getBody() {
    if (useRawBody) {
      print(convert.json.decode(rawBodyController.text));
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
    response = ExtendedResponse(res, stopwatch);
    ready();
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postwoman/constants.dart';
import 'package:postwoman/models/extended_response.dart';
import 'package:postwoman/screens/home/parameter_input.dart';
import 'package:postwoman/widgets/dropdown.dart';

enum ParameterInputType { query, header, body }

class ReponseController with ChangeNotifier {
  Map<Widget, Map<dynamic, dynamic>> queryParamMap = {};
  Map<Widget, Map<dynamic, dynamic>> headersMap = {};
  Map<Widget, Map<dynamic, dynamic>> bodyMap = {};
  String? bodyType = "application/json";
  bool isLoading = false;
  ExtendedResponse? response;

  // Controllers
  DropdownEditingController<Map<String, dynamic>> methodDropDownController =
      DropdownEditingController(value: METHODS[0]);
  TextEditingController urlInputController = TextEditingController();

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

  void loading() {
    isLoading = true;
    notifyListeners();
  }

  void ready() {
    isLoading = false;
    notifyListeners();
  }

  Map<String, dynamic> getQueryParameters() {
    var finalQuery = <String, dynamic>{};
    for (var qp in queryParamMap.values) {
      if (qp['isActive'] == true) {
        finalQuery[qp['key']] = qp['value'];
      }
    }
    return finalQuery;
  }

  Map<String, String> getHeaders() {
    var finalQuery = <String, String>{};
    for (var qp in headersMap.values) {
      if (qp['isActive'] == true) {
        finalQuery[qp['key']] = qp['value'];
      }
    }
    return finalQuery;
  }

  void fetchRequest() async {
    loading();
    var client = http.Client();
    String queryString = Uri(queryParameters: getQueryParameters()).query;
    Map<String, String> headers = getHeaders();
    final stopwatch = Stopwatch()..start();
    var res = await client.get(
        Uri.parse("${urlInputController.text}?$queryString"),
        headers: headers);
    stopwatch..stop();
    response = ExtendedResponse(res, stopwatch);
    ready();
  }
}

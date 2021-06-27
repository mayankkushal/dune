import 'package:flutter/material.dart';
import 'package:postwoman/screens/home/parameter_input.dart';

enum ParameterInputType { query, header }

class ReponseController with ChangeNotifier {
  Map<Widget, Map<dynamic, dynamic>> queryParamMap = {};
  Map<Widget, Map<dynamic, dynamic>> headersMap = {};
  bool isLoading = false;

  ReponseController() {
    addParameter(ParameterInputType.query, count: 4);
    addParameter(ParameterInputType.header, count: 4);
  }

  Map initialData = {
    ParameterInputType.query: {'isActive': false, 'key': "", 'value': ""},
    ParameterInputType.header: {'isActive': false, 'key': "", 'value': ""}
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

  void loading() {
    isLoading = true;
    notifyListeners();
  }

  void ready() {
    isLoading = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:postwoman/screens/home/parameter_input.dart';

enum ParameterInputType { query }

class ReponseController with ChangeNotifier {
  Map<Widget, Map<dynamic, dynamic>> queryParamMap = {};
  bool isLoading = false;

  ReponseController() {
    addParameter(ParameterInputType.query, count: 4);
  }

  Map initialData = {
    ParameterInputType.query: {'isActive': false, 'key': "", 'value': ""}
  };

  void removeParameterInput(
      Map<Widget, Map<dynamic, dynamic>> parameterMap, Widget input) {
    parameterMap.remove(input);
    notifyListeners();
  }

  void addParameterInput(
      Map<Widget, Map<dynamic, dynamic>> parameterMap, dynamic initial) {
    parameterMap[new ParameterInput(key: UniqueKey())] = Map.from(initial);
    notifyListeners();
  }

  Map<Widget, Map<dynamic, dynamic>> getParameterMap(ParameterInputType type) {
    switch (type) {
      case ParameterInputType.query:
        return queryParamMap;
    }
  }

  void addParameter(ParameterInputType type, {count: 1}) {
    for (var i = 0; i < count; i++) {
      addParameterInput(
          getParameterMap(type), initialData[ParameterInputType.query]);
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

  void loading() {
    isLoading = true;
    notifyListeners();
  }

  void ready() {
    isLoading = false;
    notifyListeners();
  }
}

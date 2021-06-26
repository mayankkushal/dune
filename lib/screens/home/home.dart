import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:postwoman/screens/home/parameter_input.dart';
import 'package:postwoman/screens/home/url_section.dart';
import 'package:provider/provider.dart';

import 'main_section.dart';

enum ParameterInputType { query }

class ParameterInputController with ChangeNotifier {
  Map<Widget, Map<dynamic, dynamic>> queryParamMap = {};

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
}

class Home extends HookWidget {
  final _parameterFormKey = GlobalKey<FormState>();
  final ParameterInputController parameterInputController =
      ParameterInputController();
  List<String?> keyList = [null];
  List<String?> valueList = [null];

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<http.Response?> response = useState(null);
    final urlInputController = useTextEditingController();

    useEffect(() {
      urlInputController.text = "https://jsonplaceholder.typicode.com/comments";
    });

    void fetchRequest() async {
      var client = http.Client();
      var queryParams = <String, dynamic>{};
      for (var qp in parameterInputController.queryParamMap.values) {
        if (qp['isActive'] == true) {
          queryParams[qp['key']] = qp['value'];
        }
      }
      String queryString = Uri(queryParameters: queryParams).query;
      var res = await client
          .get(Uri.parse("${urlInputController.text}?$queryString"));
      response.value = res;
    }

    return ChangeNotifierProvider.value(
      value: parameterInputController,
      child: Scaffold(
        body: Column(
          children: [
            UrlSection(
              urlInputController: urlInputController,
              onSubmitPressed: fetchRequest,
            ),
            MainSection(parameterFormKey: _parameterFormKey, response: response)
          ],
        ),
      ),
    );
  }
}

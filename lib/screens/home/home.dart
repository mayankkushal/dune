import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:postwoman/screens/home/parameter_input.dart';
import 'package:postwoman/screens/home/url_section.dart';

import 'main_section.dart';

class Home extends HookWidget {
  final urlInputController = TextEditingController();
  final _parameterFormKey = GlobalKey<FormState>();

  List<String?> keyList = [null];
  List<String?> valueList = [null];

  @override
  Widget build(BuildContext context) {
    final parameterList = useState([]);
    final ValueNotifier<http.Response?> response = useState(null);

    useEffect(() {
      urlInputController.text = "https://jsonplaceholder.typicode.com/todos/1";
    });

    void removeParameterInput(Widget input) {
      parameterList.value.remove(input);
      parameterList.value = [...parameterList.value];
    }

    void addParameterInput() {
      keyList.add(null);
      valueList.add(null);
      parameterList.value.add(ParameterInput(
          keyList, valueList, removeParameterInput,
          key: UniqueKey()));
      parameterList.value = [...parameterList.value];
    }

    void fetchRequest() async {
      var client = http.Client();
      var res = await client.get(Uri.parse(urlInputController.text));
      response.value = res;
    }

    return Scaffold(
      body: Column(
        children: [
          UrlSection(
            urlInputController: urlInputController,
            onSubmitPressed: fetchRequest,
          ),
          MainSection(
              parameterFormKey: _parameterFormKey,
              parameterList: parameterList,
              response: response,
              onPressed: addParameterInput)
        ],
      ),
    );
  }
}

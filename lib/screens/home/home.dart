import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:postwoman/controllers/response_controller.dart';
import 'package:postwoman/models/extended_response.dart';
import 'package:postwoman/screens/home/url_section.dart';
import 'package:provider/provider.dart';

import 'main_section.dart';

class Home extends HookWidget {
  final _parameterFormKey = GlobalKey<FormState>();
  final ReponseController responseController = ReponseController();
  List<String?> keyList = [null];
  List<String?> valueList = [null];

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<ExtendedResponse?> response = useState(null);
    final urlInputController = useTextEditingController();

    useEffect(() {
      urlInputController.text = "https://jsonplaceholder.typicode.com/todos/1";
    });

    void fetchRequest() async {
      responseController.loading();
      var client = http.Client();
      String queryString = Uri(queryParameters: getQueryParameters()).query;
      Map<String, String> headers = getHeaders();
      final stopwatch = Stopwatch()..start();
      var res = await client.get(
          Uri.parse("${urlInputController.text}?$queryString"),
          headers: headers);
      stopwatch..stop();
      response.value = ExtendedResponse(res, stopwatch);
      responseController.ready();
    }

    return ChangeNotifierProvider.value(
      value: responseController,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: UrlSection(
                  urlInputController: urlInputController,
                  onSubmitPressed: fetchRequest,
                ),
              ),
              MainSection(
                  parameterFormKey: _parameterFormKey, response: response)
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> getQueryParameters() {
    var finalQuery = <String, dynamic>{};
    for (var qp in responseController.queryParamMap.values) {
      if (qp['isActive'] == true) {
        finalQuery[qp['key']] = qp['value'];
      }
    }
    return finalQuery;
  }

  Map<String, String> getHeaders() {
    var finalQuery = <String, String>{};
    for (var qp in responseController.headersMap.values) {
      if (qp['isActive'] == true) {
        finalQuery[qp['key']] = qp['value'];
      }
    }
    return finalQuery;
  }
}

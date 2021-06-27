import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:postwoman/screens/home/url_section.dart';
import 'package:provider/provider.dart';

import 'main_section.dart';

class Home extends HookWidget {
  final _parameterFormKey = GlobalKey<FormState>();
  final ReponseController responseController = ReponseController();

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      responseController.urlInputController.text =
          "https://jsonplaceholder.typicode.com/todos/1";
    });

    void fetchRequest() {
      responseController.fetchRequest();
    }

    return ChangeNotifierProvider.value(
      value: responseController,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: UrlSection(
                    onSubmitPressed: fetchRequest,
                  ),
                ),
                MainSection(parameterFormKey: _parameterFormKey)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

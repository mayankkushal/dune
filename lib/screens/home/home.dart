import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:postwoman/screens/request_container/request_container.dart';
import 'package:provider/provider.dart';

class Home extends HookWidget {
  final _parameterFormKey = GlobalKey<FormState>();
  final ReponseController responseController = ReponseController();

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      responseController.urlInputController.text =
          "https://jsonplaceholder.typicode.com/todos/1";
    });

    return ChangeNotifierProvider.value(
      value: responseController,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Column(
            children: [
              Text('all the tabs go here'),
              Expanded(
                  child: RequestContainer(parameterFormKey: _parameterFormKey)),
            ],
          ),
        ),
      ),
    );
  }
}

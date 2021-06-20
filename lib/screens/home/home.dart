import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:postwoman/widgets/json_viewer.dart';

class HomeController extends GetxController {
  dynamic response = <String, dynamic>{
    "userId": 1,
    "id": 1,
    "title": {
      "userId": 1,
      "id": 1,
      "title": "delectus aut autem",
      "completed": [
        {
          "userId": 1,
          "id": 1,
          "title": "delectus aut autem",
          "completed": false
        },
        {
          "userId": 1,
          "id": 1,
          "title": "delectus aut autem",
          "completed": false
        }
      ]
    },
    "completed": false
  }.obs;

  final urlInputController = TextEditingController();
}

class Home extends StatelessWidget {
  final HomeController ctlr = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: ctlr.urlInputController,
                  ),
                ),
                ElevatedButton(onPressed: fetchRequest, child: Text("Submit"))
              ],
            ),
            JsonViewer(ctlr.response),
          ],
        ),
      ),
    );
  }

  void fetchRequest() async {
    var client = http.Client();
    print(ctlr.urlInputController.text);
    var response = await client.get(Uri.parse(ctlr.urlInputController.text));
    ctlr.response = response.body;
  }
}

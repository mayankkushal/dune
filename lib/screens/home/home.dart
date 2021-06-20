import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postwoman/widgets/json_viewer.dart';
import 'package:search_choices/search_choices.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final urlInputController = TextEditingController();
  var responseBody;

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
                  flex: 1,
                  child: SearchChoices.single(
                    items: [
                      DropdownMenuItem(child: Text('get')),
                      DropdownMenuItem(child: Text('post'))
                    ],
                    hint: "Select one",
                    searchHint: null,
                    displayClearIcon: false,
                    onChanged: print,
                    dialogBox: false,
                    isExpanded: true,
                    menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
                    autofocus: true,
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: TextField(
                    controller: urlInputController,
                  ),
                ),
                ElevatedButton(onPressed: fetchRequest, child: Text("Submit"))
              ],
            ),
            JsonViewer(responseBody),
          ],
        ),
      ),
    );
  }

  void fetchRequest() async {
    var client = http.Client();
    var response = await client.get(Uri.parse(urlInputController.text));
    setState(() {
      responseBody = json.decode(response.body);
    });
  }
}

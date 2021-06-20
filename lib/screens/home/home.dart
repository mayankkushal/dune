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
  var response;
  final _parameterFormKey = GlobalKey<FormState>();
  List<String?> keyList = [null];
  List<String?> valueList = [null];
  List<Widget> parameterList = [];

  @override
  void initState() {
    super.initState();
    urlInputController.text = "https://jsonplaceholder.typicode.com/todos/1";
    parameterList = [
      ParameterInput(keyList, valueList, removeParameterInput, key: UniqueKey())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: SearchChoices.single(
                  items: [
                    DropdownMenuItem(
                      child: Text('GET'),
                      value: 'GET',
                    ),
                    DropdownMenuItem(
                      child: Text('POST'),
                      value: 'POST',
                    )
                  ],
                  hint: "Method",
                  value: "GET",
                  searchHint: null,
                  displayClearIcon: false,
                  onChanged: print,
                  dialogBox: true,
                  isExpanded: false,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 4,
                child: Form(
                  key: _parameterFormKey,
                  child: Column(
                    children: [
                      ...parameterList,
                      ElevatedButton(
                          onPressed: addParameterInput, child: Text('Add More'))
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 6,
                child: Column(
                  children: [
                    Row(
                      children: [
                        response != null
                            ? Text("status: ${response.statusCode}")
                            : Container(),
                        Text('test')
                      ],
                    ),
                    JsonViewer(
                        response != null ? json.decode(response.body) : null),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void addParameterInput() {
    keyList.add(null);
    valueList.add(null);
    setState(() {
      parameterList.add(ParameterInput(keyList, valueList, removeParameterInput,
          key: UniqueKey()));
    });
  }

  void removeParameterInput(Widget input) {
    setState(() {
      parameterList.remove(input);
    });
  }

  void fetchRequest() async {
    var client = http.Client();
    var res = await client.get(Uri.parse(urlInputController.text));
    setState(() {
      response = res;
    });
  }
}

class ParameterInput extends StatefulWidget {
  final keyList;
  final valueList;
  final Function onDelete;
  const ParameterInput(this.keyList, this.valueList, this.onDelete, {Key? key})
      : super(key: key);

  @override
  _ParameterInputState createState() => _ParameterInputState();
}

class _ParameterInputState extends State<ParameterInput> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Checkbox(
              value: enabled,
              onChanged: (_) {
                setState(() {
                  enabled = !enabled;
                });
              }),
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Key'),
              onChanged: (value) {},
            ),
          ),
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Value'),
              onChanged: (value) {},
            ),
          ),
          InkWell(
            onTap: () => widget.onDelete(widget),
            child: Icon(
              Icons.delete_forever_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

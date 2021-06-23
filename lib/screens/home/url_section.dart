import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';

class UrlSection extends StatelessWidget {
  const UrlSection({
    Key? key,
    required this.urlInputController,
    required this.onSubmitPressed,
  }) : super(key: key);

  final TextEditingController urlInputController;
  final onSubmitPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        ElevatedButton(onPressed: onSubmitPressed, child: Text("Submit"))
      ],
    );
  }
}

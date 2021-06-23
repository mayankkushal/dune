import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ParameterInput extends HookWidget {
  final keyList;
  final valueList;
  final Function onDelete;

  const ParameterInput(this.keyList, this.valueList, this.onDelete, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enabled = useState(true);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
              value: enabled.value,
              onChanged: (_) {
                enabled.value = !enabled.value;
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
          Flexible(
            child: IconButton(
              onPressed: () => onDelete(this),
              icon: Icon(
                Icons.delete_outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

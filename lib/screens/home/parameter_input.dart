import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:postwoman/controllers/ResponseController.dart';
import 'package:provider/provider.dart';

class ParameterInput extends HookWidget {
  const ParameterInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final enabled = useState(true);
    ReponseController parameterInputController =
        Provider.of<ReponseController>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                value: parameterInputController.getValue(
                    ParameterInputType.query, this, 'isActive'),
                onChanged: (value) {
                  parameterInputController.updateValue(
                      ParameterInputType.query, this, 'isActive', value);
                }),
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Key'),
                initialValue: parameterInputController.getValue(
                    ParameterInputType.query, this, 'key'),
                onChanged: (value) {
                  parameterInputController.updateValue(
                      ParameterInputType.query, this, 'key', value);
                  parameterInputController.updateValue(
                      ParameterInputType.query, this, 'isActive', true);
                },
              ),
            ),
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Value'),
                initialValue: parameterInputController.getValue(
                    ParameterInputType.query, this, 'value'),
                onChanged: (value) {
                  parameterInputController.updateValue(
                      ParameterInputType.query, this, 'value', value);
                  parameterInputController.updateValue(
                      ParameterInputType.query, this, 'isActive', true);
                },
              ),
            ),
            Flexible(
              child: IconButton(
                onPressed: () => parameterInputController.removeParameter(
                    ParameterInputType.query, this),
                icon: Icon(
                  Icons.delete_outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

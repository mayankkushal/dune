import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:provider/provider.dart';

class ParameterInput extends HookWidget {
  const ParameterInput(this.inputType, {Key? key}) : super(key: key);

  final inputType;

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
                    inputType, this, 'isActive'),
                onChanged: (value) {
                  parameterInputController.updateValue(
                      inputType, this, 'isActive', value);
                }),
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Key'),
                initialValue:
                    parameterInputController.getValue(inputType, this, 'key'),
                onChanged: (value) {
                  parameterInputController.updateValue(
                      inputType, this, 'key', value);
                  parameterInputController.updateValue(
                      inputType, this, 'isActive', true);
                },
              ),
            ),
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Value'),
                initialValue:
                    parameterInputController.getValue(inputType, this, 'value'),
                onChanged: (value) {
                  parameterInputController.updateValue(
                      inputType, this, 'value', value);
                  parameterInputController.updateValue(
                      inputType, this, 'isActive', true);
                },
              ),
            ),
            Flexible(
              child: IconButton(
                onPressed: () =>
                    parameterInputController.removeParameter(inputType, this),
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

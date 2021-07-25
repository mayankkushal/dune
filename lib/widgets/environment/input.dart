import 'package:dune/controllers/env_controller.dart';
import 'package:dune/models/environment_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputRow extends StatelessWidget {
  final EnvironmentItem item;
  const InputRow(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final envController = context.watch<EnvController>();
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
                value: !item.disabled,
                onChanged: (value) {
                  value = value as bool;
                  envController.updateDisabled(item, !value);
                }),
            Flexible(
              child: TextFormField(
                initialValue: item.key,
                decoration: InputDecoration(labelText: 'Variable'),
                onChanged: (value) {
                  envController.updateKey(item, value);
                },
              ),
            ),
            Flexible(
              child: TextFormField(
                initialValue: item.initialValue,
                decoration: InputDecoration(labelText: 'Initial Value'),
                onChanged: (value) {
                  envController.updateInitialValue(item, value);
                },
              ),
            ),
            Flexible(
              child: TextFormField(
                initialValue: item.currentValue,
                decoration: InputDecoration(labelText: 'Current Value'),
                onChanged: (value) {
                  envController.updateCurrentValue(item, value);
                },
              ),
            ),
            Flexible(
              child: IconButton(
                onPressed: () => envController.removeInput(item),
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

import 'package:dune/controllers/env_controller.dart';
import 'package:dune/controllers/main_env_controller.dart';
import 'package:dune/controllers/main_tab_controller.dart';
import 'package:dune/widgets/environment/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class EnvironmentContainer extends HookWidget {
  const EnvironmentContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final envController = context.watch<EnvController>();
    final mainEnvController = MainEnvController.to;
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TextFormField(
                initialValue: envController.environment.name,
                readOnly: envController.environment.isGlobal,
                onChanged: (value) {
                  envController.updateName(value);
                  mainEnvController.reload.value =
                      !mainEnvController.reload.value;
                  mainEnvController.update();
                  MainTabController.to.update();
                },
              ),
            ),
            ElevatedButton(
                onPressed: envController.dirty
                    ? () => envController.save(envController.environment)
                    : null,
                child: Text('Save'))
          ],
        ),
        Flexible(
          flex: 8,
          fit: FlexFit.tight,
          child: ListView.builder(
            itemBuilder: (context, i) =>
                InputRow(envController.environment.items[i]),
            itemCount: envController.environment.items.length,
          ),
        ),
        IconButton(
            onPressed: () => envController.addInput(), icon: Icon(Icons.add))
      ],
    );
  }
}

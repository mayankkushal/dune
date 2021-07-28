import 'package:dune/controllers/response_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class AuthInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    ResponseController responseController =
        Provider.of<ResponseController>(context);

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DropdownButton<String>(
            value: responseController.authType,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              responseController.updateAuthType(newValue);
            },
            items: AUTH_OPTIONS.values
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      responseController.authType == AUTH_OPTIONS[BASIC]
          ? Container(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: responseController.basicAuth['username'],
                    decoration: InputDecoration(labelText: 'Username'),
                    onChanged: (value) =>
                        responseController.updateBasicAuth("username", value),
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      initialValue: responseController.basicAuth['password'],
                      onChanged: (value) => responseController.updateBasicAuth(
                          "password", value)),
                ],
              ),
            )
          : responseController.authType == AUTH_OPTIONS[BEARER_TOKEN]
              ? Container(
                  child: TextFormField(
                    initialValue: responseController.bearerToken,
                    decoration: InputDecoration(labelText: 'Token'),
                    onChanged: (value) =>
                        responseController.updateBearerToken(value),
                  ),
                )
              : Container()
    ]);
  }
}

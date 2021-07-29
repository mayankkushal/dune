import 'package:dune/controllers/request_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class AuthInput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    RequestController requestController =
        Provider.of<RequestController>(context);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropdownButton<String>(
              value: requestController.authType,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              onChanged: (String? newValue) {
                requestController.updateAuthType(newValue);
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
        if (requestController.authType == AUTH_OPTIONS[BASIC])
          BasicAuthContainer(requestController: requestController)
        else if (requestController.authType == AUTH_OPTIONS[BEARER_TOKEN])
          BearerTokenContainer(requestController: requestController)
        else
          Container()
      ]),
    );
  }
}

class BearerTokenContainer extends StatelessWidget {
  const BearerTokenContainer({
    Key? key,
    required this.requestController,
  }) : super(key: key);

  final RequestController requestController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: requestController.bearerToken['key'],
          decoration: InputDecoration(labelText: 'Key'),
          onChanged: (value) =>
              requestController.updateBearerToken('key', value),
        ),
        TextFormField(
          initialValue: requestController.bearerToken['token'],
          decoration: InputDecoration(labelText: 'Token'),
          onChanged: (value) =>
              requestController.updateBearerToken('token', value),
        )
      ],
    );
  }
}

class BasicAuthContainer extends StatelessWidget {
  const BasicAuthContainer({
    Key? key,
    required this.requestController,
  }) : super(key: key);

  final RequestController requestController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            initialValue: requestController.basicAuth['username'],
            decoration: InputDecoration(labelText: 'Username'),
            onChanged: (value) =>
                requestController.updateBasicAuth("username", value),
          ),
          TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              initialValue: requestController.basicAuth['password'],
              onChanged: (value) =>
                  requestController.updateBasicAuth("password", value)),
        ],
      ),
    );
  }
}

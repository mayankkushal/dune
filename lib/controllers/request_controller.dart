import 'dart:convert' as convert;
import 'dart:convert';

import 'package:code_text_field/code_text_field.dart';
import 'package:dio/dio.dart';
import 'package:dune/constants.dart';
import 'package:dune/controllers/history_controller.dart';
import 'package:dune/controllers/request_logger.dart';
import 'package:dune/controllers/url_controller.dart';
import 'package:dune/extensions/string_apis.dart';
import 'package:dune/models/extended_response.dart';
import 'package:dune/schema/item.dart';
import 'package:dune/widgets/request_container/parameter_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/json.dart';

enum ParameterInputType { query, header, body }
const INITIAL_INPUT_COUNT = 4;

class RequestController with ChangeNotifier {
  Map<String, dynamic> storedRequest = {};

  Map<Widget, Map<dynamic, dynamic>> queryParamMap = {};
  Map<Widget, Map<dynamic, dynamic>> headersMap = {};
  Map<Widget, Map<dynamic, dynamic>> bodyMap = {};

  String? bodyType = "application/json";
  bool useRawBody = false;

  bool isLoading = false;

  // auth
  String? authType = AUTH_OPTIONS[NONE];
  Map<String, String> basicAuth = {"username": "", "password": ""};
  Map<String, String> bearerToken = {"key": "Bearer", "token": ""};

  ExtendedResponse? response;
  Item? parsedResponse;
  var dio = Dio();

  // Controllers
  // URL Controller
  late UrlController urlController;
  // Controller to handle raw body input
  late CodeController rawBodyController;

  RequestController(this.urlController, Item? data) {
    if (data != null) {
      loadPageData(data);
    } else {
      initializeFreshPage();
    }
    // this.urlController = urlController;
    dio.interceptors.add(
      RequestLogger(
          onAddHistory: (object, item) {
            response!.parsedResponse.request = item.request;
            response!.parsedResponse.protocolProfileBehavior =
                item.protocolProfileBehavior;
            response!.parsedResponse.response = item.response;
            HistoryController.to.addHistory(object, item);
          },
          addHistory: true),
    );
  }

  void loadPageData(Item data) {
    loadInputParam(ParameterInputType.query, data.request?.url?.query ?? "");
    loadInputParam(ParameterInputType.header, data.request?.header ?? "");
    loadRequestBody(data);
    response = ExtendedResponse(data);
    parsedResponse = data;
  }

  void loadRequestBody(Item data) {
    useRawBody = true;
    rawBodyController = CodeController(
      text: data.request?.body?.raw ?? "{\n\t\n}",
      patternMap: {
        ENV_REGEX:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent),
      },
      language: json,
      theme: monokaiSublimeTheme,
    );
  }

  void initializeFreshPage() {
    addParameter(ParameterInputType.query, count: INITIAL_INPUT_COUNT);
    addParameter(ParameterInputType.header, count: INITIAL_INPUT_COUNT);
    addParameter(ParameterInputType.body, count: INITIAL_INPUT_COUNT);
    response = ExtendedResponse(Item());
    rawBodyController = CodeController(
      text: "{ \n\t\n}",
      patternMap: {
        ENV_REGEX:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent),
      },
      language: json,
      theme: monokaiSublimeTheme,
    );
  }

  void loadInputParam(ParameterInputType type, dynamic data) {
    if (data.length > 0) {
      data.forEach((input) => addParameter(type, data: input.toMap()));
    }
    addParameter(type, count: INITIAL_INPUT_COUNT - data.length);
  }

  Map initialData = {
    ParameterInputType.query: {'disabled': true, 'key': "", 'value': ""},
    ParameterInputType.header: {'disabled': true, 'key': "", 'value': ""},
    ParameterInputType.body: {'disabled': true, 'key': "", 'value': ""}
  };

  void removeParameterInput(
      Map<Widget, Map<dynamic, dynamic>> parameterMap, Widget input) {
    parameterMap.remove(input);
    notifyListeners();
  }

  void addParameterInput(ParameterInputType type,
      Map<Widget, Map<dynamic, dynamic>> parameterMap, dynamic initial) {
    parameterMap[new ParameterInput(type, key: UniqueKey())] =
        Map.from(initial);
    notifyListeners();
  }

  Map<Widget, Map<dynamic, dynamic>> getParameterMap(ParameterInputType type) {
    switch (type) {
      case ParameterInputType.query:
        return queryParamMap;
      case ParameterInputType.header:
        return headersMap;
      case ParameterInputType.body:
        return bodyMap;
    }
  }

  void addParameter(ParameterInputType type, {count: 1, data}) {
    if (data == null) {
      data = initialData[type];
    }
    for (var i = 0; i < count; i++) {
      addParameterInput(type, getParameterMap(type), data);
    }
  }

  void removeParameter(ParameterInputType type, Widget input) {
    removeParameterInput(getParameterMap(type), input);
  }

  void updateName(String name) {
    response?.parsedResponse.name = name;
  }

  void updateBasicAuth(String key, String value) {
    basicAuth[key] = value;
    notifyListeners();
  }

  void updateBearerToken(String key, String value) {
    bearerToken[key] = value;
    notifyListeners();
  }

  void updateValue(
      ParameterInputType type, Widget input, String key, dynamic value) {
    getParameterMap(type)[input]![key] = value;
    notifyListeners();
  }

  dynamic getValue(ParameterInputType type, Widget input, String key) {
    return getParameterMap(type)[input]![key];
  }

  void updateBodyType(String? value) {
    bodyType = value;
    notifyListeners();
  }

  void updateAuthType(String? value) {
    authType = value;
    notifyListeners();
  }

  void updateRawBody(bool value) {
    useRawBody = value;
    notifyListeners();
  }

  void loading() {
    isLoading = true;
    notifyListeners();
  }

  void ready() {
    isLoading = false;
    notifyListeners();
  }

  bool checkDirty() {
    if (response!.parsedResponse.toMap().toString() !=
        storedRequest.toString()) {
      return true;
    }
    return false;
  }

  void save() {}

  Map<String, dynamic> getParameterInputAsMap(ParameterInputType type) {
    var finalQuery = <String, String>{};
    for (var qp in getParameterMap(type).values) {
      if (qp['disabled'] == false) {
        var value = (qp['value'] as String).parseEnv();
        var key = (qp['key'] as String).parseEnv();
        finalQuery[key] = value;
      }
    }
    return finalQuery;
  }

  Map<String, dynamic> getBody() {
    if (useRawBody) {
      return convert.json.decode(rawBodyController.text.parseEnv());
    }
    return getParameterInputAsMap(ParameterInputType.body);
  }

  Map<String, dynamic> getHeaders() {
    Map<String, dynamic> headers =
        getParameterInputAsMap(ParameterInputType.header);
    if (authType == AUTH_OPTIONS[BASIC]) {
      headers['authorization'] =
          "Basic ${base64Encode(utf8.encode('${(basicAuth["username"] as String).parseEnv()}:${(basicAuth["password"] as String).parseEnv()}'))}";
    } else if (authType == AUTH_OPTIONS[BEARER_TOKEN]) {
      headers['authorization'] =
          "${(bearerToken['key'] as String).parseEnv()} ${(bearerToken['token'] as String).parseEnv()}";
    }
    return headers;
  }

  void fetchRequest() async {
    loading();
    final stopwatch = Stopwatch()..start();
    late var res;
    try {
      res = await dio.request(
        urlController.urlInputController.text.parseEnv(),
        queryParameters: getParameterInputAsMap(ParameterInputType.query),
        data: getBody(),
        options: Options(
            method: urlController.methodDropDownController.value!['name'],
            headers: getHeaders(),
            responseType: ResponseType.plain),
      );
    } catch (e) {
      if (e is DioError) {
        res = e.response;
      } else {
        res = {};
      }
    }
    stopwatch..stop();
    // response = ExtendedResponse(parsedResponse as Item,
    //     response: res, stopwatch: stopwatch);
    response!.response = res;
    response!.stopwatch = stopwatch;
    ready();
  }
}

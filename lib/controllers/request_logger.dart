import 'package:dio/dio.dart';
import 'package:dune/schema/collection.dart';
import 'package:dune/schema/item.dart';
import 'package:dune/schema/request_item.dart';
import 'package:dune/schema/response_item.dart';
import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class RequestLogger extends Interceptor {
  RequestLogger({
    this.logPrint = print,
    this.onAddHistory,
    this.enablePrint = false,
    this.addHistory = false,
    this.maxMilliseconds,
  });

  // ignore: use_setters_to_change_properties
  static void changeNameCollection(String name) {
    collection.info!.name = name;
  }

  static Collection collection = Collection(
    info: InfoCollection(
        name: 'RequestLogger ${DateTime.now().toUtc()}',
        schema:
            'https://schema.getpostman.com/json/collection/v2.1.0/collection.json'),
    item: [],
  );

  final stopwatch = Stopwatch();
  final bool enablePrint;
  final bool addHistory;

  /// Log if the request is executed more than maxMilliseconds ms, if 'null' log all request
  final int? maxMilliseconds;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(Object object) logPrint;
  void Function(Object object, dynamic returnValue)? onAddHistory;

  // you can override this for change your log value
  Future<String?>? getPrintValue(Item? request) => getPrintJson(request);

  Item? newRequest;

  /// JSON collection for import by the postman or another client
  static Future<String> export() async {
    return collection.toJson();
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler? handler) async {
    try {
      stopwatch.start();
      newRequest = Item(
        name: options.safeUri?.toString(),
        request: await RequestItem.fromRequest(options),
      );
      collection.item!.add(newRequest);
    } catch (error, stackTrace) {
      l.log('$error',
          name: 'RequestLogger', error: error, stackTrace: stackTrace);
    }
    return handler?.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler? handler) async {
    try {
      _checkTime();
      newRequest ??= Item(
        name: err.response?.requestOptions.path == null
            ? null
            : err.response?.requestOptions.uri.toString(),
        request: await RequestItem.fromRequest(err.response?.requestOptions),
      );
      newRequest!
        ..name = '[${stopwatch.elapsedMilliseconds}ms] ${newRequest!.name}'
        ..request = newRequest!.request?.copyWith(
          description: err.toString(),
        )
        ..response = <ResponseItem>[
          ResponseItem(
            name: err.requestOptions.safeUri?.toString(),
            code: err.response?.statusCode,
            status: err.response?.statusMessage,
            originalRequest: await RequestItem.fromRequest(err.requestOptions),
            responseTime: stopwatch.elapsedMilliseconds,
            body: await TransformerJson.encode(err.response?.data),
            header: err.response?.headers.map.keys
                .map((key) => HeaderPostman(
                      key: key,
                      value: err.response?.headers[key]?.toString(),
                    ))
                .toList(),
          ),
        ];
      await _log();
    } catch (error, stackTrace) {
      l.log('$error',
          name: 'RequestLogger', error: error, stackTrace: stackTrace);
    }
    return handler?.next(err);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler? handler) async {
    try {
      _checkTime();
      newRequest!
        ..name = '[${stopwatch.elapsedMilliseconds}ms] ${newRequest!.name}'
        ..request = newRequest!.request?.copyWith(
          description: response.toString(),
        )
        ..response = <ResponseItem>[
          ResponseItem(
            name: response.requestOptions.safeUri?.toString(),
            code: response.statusCode,
            status: response.statusMessage,
            originalRequest:
                await RequestItem.fromRequest(response.requestOptions),
            responseTime: stopwatch.elapsedMilliseconds,
            body: await TransformerJson.encode(response.data),
            header: response.headers.map.keys
                .map((key) => HeaderPostman(
                      key: key,
                      value: response.headers[key]?.toString(),
                    ))
                .toList(),
          ),
        ];
      await _log();
    } catch (error, stackTrace) {
      l.log('$error',
          name: 'RequestLogger', error: error, stackTrace: stackTrace);
    }
    return handler?.next(response);
  }

  void _checkTime() {
    stopwatch.stop();
    if (maxMilliseconds != null) {
      if (stopwatch.elapsedMilliseconds < maxMilliseconds!) {
        collection.item!.remove(newRequest);
      }
    }
  }

  Future<void> _log() async {
    if (enablePrint) {
      if (maxMilliseconds != null) {
        if (stopwatch.elapsedMilliseconds < maxMilliseconds!) {
          return;
        }
      }
      logPrint(await getPrintValue(newRequest) ?? '');
    } else if (addHistory) {
      onAddHistory!(await getPrintValue(newRequest) ?? '', newRequest);
    }
  }

  Future<String?>? getPrintJson(Item? request) async {
    return request?.toJson();
  }

  Future<String> getPrintSimple(Item? request) async {
    return '${request?.request?.method}:${request?.response?.firstOrDefault?.code} ${request?.request?.url?.raw}';
  }
}

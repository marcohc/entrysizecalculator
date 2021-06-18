import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';

class ApiCallsManager {

  ApiCallsManager(this._apiKey);

  final String _apiKey;

  final allCancelTokens = <CancelToken>[];

  Dio get _dio => Dio()
    ..interceptors.add(dioLoggerInterceptor)
    ..options.headers = {'X-MBX-APIKEY': this._apiKey}
    ..options.connectTimeout = 5000
    ..options.receiveTimeout = 5000;

  Future<dynamic> getJson(String url, {int? timeout}) async {
    final response = await _executeCall((dio, cancelToken) => dio.get<dynamic>(url, cancelToken: cancelToken), timeout: timeout);
    return response.data;
  }

  Future<dynamic> getRaw(String url, {int? timeout}) async {

    return _dio.get(url);

    // return _executeCall((dio, cancelToken) => dio.get(url, cancelToken: cancelToken), timeout: timeout);
  }

  Future<dynamic> postRaw(String url, {Map<String, dynamic>? body, int? timeout}) async {
    final encodedBody = body == null ? null : json.encode(body).toString();
    return _executeCall((dio, cancelToken) => dio.post(url, data: encodedBody, cancelToken: cancelToken), timeout: timeout);
  }

  Future<dynamic> deleteRaw(String url, {int? timeout}) async {
    return _executeCall((dio, cancelToken) => dio.delete(url, cancelToken: cancelToken), timeout: timeout);
  }

  void cancelAll() {
    allCancelTokens.forEach((element) => element.cancel());
    allCancelTokens.clear();
  }

  Future<Response<dynamic>> _executeCall(Function(Dio, CancelToken) dioRequestFuture, {int? timeout}) async {
    final token = CancelToken();

    final dio = _dio;
    // _dio.interceptors.add(RetryInterceptor(dio: dio, urlResolver: urlResolver));

    if (timeout != null) {
      dio
        ..options.connectTimeout = timeout
        ..options.receiveTimeout = timeout;
    }

    allCancelTokens.add(token);
    final response = await dioRequestFuture(dio, token);
    allCancelTokens.remove(token);

    return response;
  }
}

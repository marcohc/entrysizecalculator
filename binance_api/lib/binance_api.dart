import 'dart:convert';

import 'package:binance_api/api_utils.dart';
import 'package:binance_api/app_prefs.dart';
import 'package:binance_api/model/account_info.dart';
import 'package:binance_api/model/error.dart';
import 'package:binance_api/model/exchange_info.dart';
import 'package:binance_api/model/order.dart';
import 'package:binance_api/model/place_order.dart';
import 'package:binance_api/model/snapshot.dart';
import 'package:binance_api/utils/api_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:either_option/either_option.dart';

const _baseUrl = 'https://api.binance.com';

// Anonymous endpoints
const _endpointStatus = '/sapi/v1/system/status';
const _serverTime = '/api/v3/time';
const _avgPrice = '/api/v3/avgPrice';
const _exchangeInfo = '/api/v3/exchangeInfo';

// Sign endpoints
const _accountSnapshot = '/sapi/v1/accountSnapshot';

const _accountInfo = '/api/v3/account';
const _allOrders = '/api/v3/allOrders';
const _openOrders = '/api/v3/openOrders';
const _endpointOrderTest = '/api/v3/order/test'; //api/v3/order/test

enum Method { POST, GET, DELETE }

class BinanceApi {
  BinanceApi({required this.apiKey, required this.secret}) : client = ApiCallsManager(apiKey) {
    AppPreferences.init();
  }

  final String apiKey;
  final String secret;
  final ApiCallsManager client;

//region Anonymous endpoints

  Future<Map<String, dynamic>> systemStatus() async {
    final response = await _getCall(_endpointStatus);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getServerTime() async {
    final response = await _getCall(_serverTime);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> averagePrice(String symbol) async {
    final response = await _getCall(_avgPrice, 'symbol=$symbol');
    return response as Map<String, dynamic>;
  }

  Future<Either<ErrorModel, ExchangeInfo>> exchangeInfo() async {
    return await executeSafely(
      'exchangeInfo',
      _getCall(_exchangeInfo),
      (result) => ExchangeInfo.fromJson(result as Map<String, dynamic>),
    );
    // final response = await _getCall(_exchangeInfo);
    // return response as Map<String, dynamic>;
  }

//endregion

//region Sign endpoints

  Future<Either<ErrorModel, List<Snapshot>>> getAccountSnapshot({String type = 'SPOT'}) =>
      executeSafely<Map<String, dynamic>, List<Snapshot>>(
        'getAccountSnapshot',
        _executeTimeAdjusted(_accountSnapshot, query: {'type': type}),
        (result) {
          final jsonList = result['snapshotVos'] as List<Map<String, dynamic>>;
          final snapshots = jsonList.map((element) => Snapshot.fromJson(element));
          return snapshots.toList();
        },
      );

  Future<Either<ErrorModel, AccountInfo>> getAccountInfo() => executeSafely<Map<String, dynamic>, AccountInfo>(
        'getAccountInfo',
        _executeTimeAdjusted(_accountInfo),
        (result) => AccountInfo.fromJson(result),
      );

  Future<Either<ErrorModel, List<Order>>> getAllOrders({String symbol = 'ETHBTC'}) => executeSafely<Map<String, dynamic>, List<Order>>(
        'getAllOrders',
        _executeTimeAdjusted(_allOrders, query: {'symbol': symbol}),
        (result) {
          final list = result as List<Map<String, dynamic>>;
          final mapped = list.map((element) => Order.fromJson(element));
          return mapped.toList();
        },
      );

  Future<Either<ErrorModel, List<Order>>> getOpenOrders({String symbol = 'ETHBTC'}) => executeSafely<Map<String, dynamic>, List<Order>>(
        'getOpenOrders',
        _executeTimeAdjusted(_openOrders, query: {'symbol': symbol}),
        (result) {
          final list = result as List<Map<String, dynamic>>;
          final mapped = list.map((element) => Order.fromJson(element));
          return mapped.toList();
        },
      );

  // TODO: Implement for CurrencyPairs screen
  Future<Either<ErrorModel, List<dynamic>>> getAllPairs({String symbol = 'BTC'}) async => Right(<dynamic>[]);

  Future<Either<ErrorModel, Order>> placeTestOrder(PlaceOrder order) => executeSafely<Map<String, dynamic>, Order>(
        'placeTestOrder',
        _executeTimeAdjusted(
          _endpointOrderTest,
          query: order.toJson(),
          method: Method.POST,
        ),
        (result) => Order.fromJson(result),
      );

//endregion

//region helper methods

  Future<dynamic> _getCall(String endPoint, [String query = '']) async =>
      await client.getJson('$_baseUrl$endPoint${query.isEmpty ? '' : '&$query'}');

  Future<Map<String, dynamic>> _executeTimeAdjusted(String endPoint, {Map<String, dynamic>? query, Method method = Method.GET}) async {
    try {
      final signedQuery = _sighQuery(endPoint, query ?? {});

      var response;
      switch (method) {
        case Method.POST:
          response = await client.postRaw(signedQuery);
          break;
        case Method.GET:
          response = await client.getRaw(signedQuery);
          break;
        case Method.DELETE:
          response = await client.deleteRaw(signedQuery);
          break;
      }

      return (response as Response).data;
    } on DioError catch (error) {
      if ((error.response?.data as Map<String, dynamic>?)?['code'] == -1021) {
        final sTime = await getServerTime();
        final serverTime = sTime['serverTime'] as int;
        final timeAdjustment = DateTime.now().millisecondsSinceEpoch - serverTime;
        AppPreferences.storeTimeAdjustment(timeAdjustment);
        print('Setup timeAdjustment: $timeAdjustment');
      } else {
        rethrow;
      }
    }

    return _executeTimeAdjusted(endPoint, query: query);
  }

  String _sighQuery(String endPoint, Map<String, dynamic> query) {
    final timeAdjustment = AppPreferences.getTimeAdjustment();
    final dateTime = DateTime.now().subtract(Duration(milliseconds: timeAdjustment));
    final timestamp = "timestamp=" + dateTime.millisecondsSinceEpoch.toString();
    print(timestamp);
    final queryWithTimeStamp =
        query.keys.where((key) => query[key] != null).fold('', (previousValue, key) => '$previousValue$key=${query[key]}&') + timestamp;

    final key = utf8.encode(secret);
    final bytes = utf8.encode(queryWithTimeStamp);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    return _baseUrl + endPoint + "?" + queryWithTimeStamp + '&signature=${digest.toString()}';
  }

//endregion
}

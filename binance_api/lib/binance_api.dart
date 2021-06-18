import 'dart:convert';

import 'package:binance_api/api_utils.dart';
import 'package:binance_api/app_prefs.dart';
import 'package:binance_api/model/account_info.dart';
import 'package:binance_api/model/error.dart';
import 'package:binance_api/model/order.dart';
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

// Sign endpoints
const _accountSnapshot = '/sapi/v1/accountSnapshot';

const _accountInfo = '/api/v3/account';
const _allOrders = '/api/v3/allOrders';

class BinanceApi {
  BinanceApi({required this.apiKey, required this.secret}) : client = ApiCallsManager(apiKey);

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

//endregion

//region Sign endpoints
//
  Future<Either<ErrorModel, List<Snapshot>>> getAccountSnapshot({String type = 'SPOT'}) =>
      executeSafely<Map<String, dynamic>, List<Snapshot>>(
        'getAccountSnapshot',
        _executeTimeAdjusted(_accountSnapshot, 'type=$type'),
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
        _executeTimeAdjusted(_allOrders, 'symbol=$symbol'),
        (result) {
          final list = result as List<Map<String, dynamic>>;
          final mapped = list.map((element) => Order.fromJson(element));
          return mapped.toList();
        },
      );

//endregion

//region helper methods

  Future<dynamic> _getCall(String endPoint, [String query = '']) async =>
      await client.getJson('$_baseUrl$endPoint${query.isEmpty ? '' : '&$query'}');

  Future<Map<String, dynamic>> _executeTimeAdjusted(String endPoint, [String query = '']) async {
    try {
      final signedQuery = _sighQuery(endPoint, query);
      final response = await client.getRaw(signedQuery);
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

    return _executeTimeAdjusted(endPoint, query);
  }

  String _sighQuery(String endPoint, [String query = '']) {
    final timeAdjustment = AppPreferences.getTimeAdjustment();
    final dateTime = DateTime.now().subtract(Duration(milliseconds: timeAdjustment));
    final timestamp = "timestamp=" + dateTime.millisecondsSinceEpoch.toString();
    print(timestamp);
    final queryWithTimeStamp = query + '&' + timestamp;

    final key = utf8.encode(secret);
    final bytes = utf8.encode(queryWithTimeStamp);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    return _baseUrl + endPoint + "?" + queryWithTimeStamp + '&signature=${digest.toString()}';
  }

//endregion
}

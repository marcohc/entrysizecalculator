// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'order.freezed.dart';
// part 'order.g.dart';
//
// @freezed
// abstract class Order with _$Order {
//   const Order._();
//
//   const factory Order({
//     required String symbol,
//     required int orderId,
//     required int orderListId,
//     required String clientOrderId,
//     required String price,
//     required String origQty,
//     required String executedQty,
//     required String cummulativeQuoteQty,
//     required String status,
//     required String timeInForce,
//     required String type,
//     required String side,
//     required String stopPrice,
//     required String icebergQty,
//     required int time,
//     required int updateTime,
//     required bool isWorking,
//     required String origQuoteOrderQty,
//   }) = _Order;
//
//   factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
//
// }
//
//
// // [
// // {
// // "symbol": "LTCBTC",
// // "orderId": 1,
// // "orderListId": -1, //Unless OCO, the value will always be -1
// // "clientOrderId": "myOrder1",
// // "price": "0.1",
// // "origQty": "1.0",
// // "executedQty": "0.0",
// // "cummulativeQuoteQty": "0.0",
// // "status": "NEW",
// // "timeInForce": "GTC",
// // "type": "LIMIT",
// // "side": "BUY",
// // "stopPrice": "0.0",
// // "icebergQty": "0.0",
// // "time": 1499827319559,
// // "updateTime": 1499827319559,
// // "isWorking": true,
// // "origQuoteOrderQty": "0.000000"
// // }
// // ]

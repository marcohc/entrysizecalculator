import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_order.g.dart';

@JsonSerializable()
class PlaceOrder {
  factory PlaceOrder.fromJson(Map<String, dynamic> json) => _$PlaceOrderFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceOrderToJson(this);

  PlaceOrder({required this.symbol, required this.side, required this.type});

// class PlaceOrder {
  //todo add parameters assertion per Type
  PlaceOrder._({
    required this.symbol,
    required this.side,
    required this.type,
    this.timeInForce,
    this.quantity,
    this.quoteOrderQty,
    this.price,
    this.newClientOrderId,
    this.stopPrice,
    this.icebergQty,
    this.newOrderRespType,
  });

  /// Provide quantity for Base Currency or quoteOrderQty for target currency
  factory PlaceOrder.marketBuy(
    String symbol, {
    double? quantity,
    double? quoteOrderQty,
  }) {
    assert(quantity != null || quoteOrderQty != null);
    return PlaceOrder._(
      type: Type.MARKET,
      side: Side.BUY,
      symbol: symbol,
      quantity: quantity,
      quoteOrderQty: quoteOrderQty,
    );
  }


  factory PlaceOrder.marketSell(
      String symbol, {
        double? quantity,
        double? quoteOrderQty,
      }) {
    assert(quantity != null || quoteOrderQty != null);
    return PlaceOrder._(
      type: Type.MARKET,
      side: Side.SELL,
      symbol: symbol,
      quantity: quantity,
      quoteOrderQty: quoteOrderQty,
    );
  }
  // symbol=BTCUSDT
  // &side=SELL
  // &type=LIMIT
  // &timeInForce=GTC
  // &quantity=0.01
  // &price=9000
  // &newClientOrderId=my_order_id_1

  factory PlaceOrder.test() {
    // assert(quantity != null || quoteOrderQty != null);
    return PlaceOrder._(
      type: Type.LIMIT,
      side: Side.SELL,
      symbol: 'BTCUSDT',
      quantity: 0.01,
      price: 9000,
      newClientOrderId: 'my_order_id_1',
    );
  }


  String symbol;
  Side side;
  Type type;
  TimeInForce? timeInForce;

  /// MARKET orders using the quantity field specifies the amount of the base asset the user
  /// wants to buy or sell at the market price.
  // For example, sending a MARKET order on BTCUSDT will specify how much BTC the user
  // is buying or selling.
  double? quantity;

  ///MARKET orders using quoteOrderQty specifies the amount the user wants to spend (when buying)
  ///or receive (when selling) the quote asset; the correct quantity will be determined based
  ///on the market liquidity and quoteOrderQty.
  double? quoteOrderQty;
  double? price;

  /// A unique id among open orders. Automatically generated if not sent.
  String? newClientOrderId;

  ///Used with STOP_LOSS, STOP_LOSS_LIMIT, TAKE_PROFIT, and TAKE_PROFIT_LIMIT orders.
  double? stopPrice;

  ///Used with LIMIT, STOP_LOSS_LIMIT, and TAKE_PROFIT_LIMIT to create an iceberg order.
  double? icebergQty;

  ///Set the response JSON. ACK, RESULT, or FULL; MARKET and LIMIT order types default to FULL, all other orders default to ACK.
  NewOrderRespType? newOrderRespType;
}

enum Side { BUY, SELL }
enum Type {
  LIMIT, //timeInForce, quantity, price
  MARKET, //quantity or quoteOrderQty
  STOP_LOSS, //quantity, stopPrice
  STOP_LOSS_LIMIT, //timeInForce, quantity, price, stopPrice
  TAKE_PROFIT, //quantity, stopPrice
  TAKE_PROFIT_LIMIT, //timeInForce, quantity, price, stopPrice
  LIMIT_MAKER, //	quantity, price
}

enum TimeInForce { GTC }

enum NewOrderRespType { ACK, RESULT, FULL }

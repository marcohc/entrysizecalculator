import 'package:json_annotation/json_annotation.dart';

part 'symbol.g.dart';

@JsonSerializable()
class Symbol {
  factory Symbol.fromJson(Map<String, dynamic> json) => _$SymbolFromJson(json);

  Map<String, dynamic> toJson() => _$SymbolToJson(this);

  Symbol(
    this.symbol,
    this.status,
    this.baseAsset,
    this.baseAssetPrecision,
    this.quoteAsset,
    this.quotePrecision,
    this.quoteAssetPrecision,
    this.baseCommissionPrecision,
    this.quoteCommissionPrecision,
    this.icebergAllowed,
    this.ocoAllowed,
    this.quoteOrderQtyMarketAllowed,
    this.isSpotTradingAllowed,
    this.isMarginTradingAllowed,
  );

  final String symbol;
  final String status;
  final String baseAsset;
  final double baseAssetPrecision;
  final String quoteAsset;
  final double quotePrecision;
  final double quoteAssetPrecision;
  final double baseCommissionPrecision;
  final double quoteCommissionPrecision;
  final bool icebergAllowed;
  final bool ocoAllowed;
  final bool quoteOrderQtyMarketAllowed;
  final bool isSpotTradingAllowed;
  final bool isMarginTradingAllowed;
}

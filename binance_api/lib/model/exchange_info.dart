import 'package:binance_api/model/symbol.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange_info.g.dart';

@JsonSerializable()
class ExchangeInfo {
  factory ExchangeInfo.fromJson(Map<String, dynamic> json) => _$ExchangeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeInfoToJson(this);

  ExchangeInfo(
    this.timezone,
    this.serverTime,
    this.symbols,
  );

  final String timezone;
  final double serverTime;

  // final List<RateLimit> rateLimits;
  // final List<ExchangeFilters> exchangeFilters;
  final List<Symbol> symbols;
}

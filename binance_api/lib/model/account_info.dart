import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_info.freezed.dart';

part 'account_info.g.dart';

@freezed
abstract class Balance with _$Balance {
  const Balance._();

  const factory Balance({
    required String asset,
    required String free,
    required String locked,
  }) = _Balance;

  factory Balance.fromJson(Map<String, dynamic> json) => _$BalanceFromJson(json);

  bool get isNotEmpty => total != 0;

  double get total => double.parse(free) + double.parse(locked);
}

@freezed
class AccountInfo with _$AccountInfo {
  const factory AccountInfo({
    required int makerCommission,
    required int takerCommission,
    required int buyerCommission,
    required int sellerCommission,
    required bool canTrade,
    required bool canWithdraw,
    required bool canDeposit,
    required int updateTime,
    required String accountType,
    required List<Balance> balances,
  }) = _AccountInfo;

  factory AccountInfo.fromJson(Map<String, dynamic> json) => _$AccountInfoFromJson(json);
}

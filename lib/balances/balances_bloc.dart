import 'package:binance_api/binance_api.dart';
import 'package:binance_api/model/account_info.dart';
import "package:bloc/bloc.dart";
import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_navigator.dart';

class BalancesState {
  BalancesState({this.loading = true, this.error = true, this.items});

  final bool loading;
  final bool error;
  final List<BalancesItem>? items;

  BalancesState copyWith(
          {bool loading = true,
          bool error = true,
          List<BalancesItem>? items}) =>
      BalancesState(
        loading: loading,
        error: error,
        items: items ?? this.items,
      );
}

abstract class BalancesEvent {}

class OnItemClickEvent extends BalancesEvent {
  OnItemClickEvent(this.item);

  final BalancesItem item;
}

class OnPullToRefreshEvent extends BalancesEvent {}

class InitEvent extends BalancesEvent {}

// TODO:
// - Show loading first time
// - Display data or empty screen
// - Pull to refresh triggers data again
class BalancesBloc extends Bloc<BalancesEvent, BalancesState> {
  BalancesBloc() : super(BalancesState()) {
    add(InitEvent());
  }

  final _navigator = GetIt.instance.get<AppNavigator>();
  final _binanceApi = GetIt.instance.get<BinanceApi>();

  @override
  Stream<BalancesState> mapEventToState(BalancesEvent event) async* {
    if (event is InitEvent) {
      emit(state.copyWith(loading: true));
      final result = await _binanceApi.getAccountInfo();
      // final result = Right(AccountInfo(
      //     makerCommission: 0,
      //     takerCommission: 0,
      //     buyerCommission: 0,
      //     sellerCommission: 0,
      //     canTrade: true,
      //     canWithdraw: true,
      //     canDeposit: true,
      //     updateTime: 0,
      //     accountType: "",
      //     balances: [Balance(asset: "ETH", free: "0.085", locked: "0.005")]));
      result.fold((error) {
        emit(state.copyWith(loading: false, error: true));
      }, (accountInfo) {
        final items = accountInfo.balances
            .map((balance) =>
                BalancesItem(balance.asset, balance.total.toString()))
            .toList();
        emit(state.copyWith(loading: false, items: items));
      });
    } else if (event is OnItemClickEvent) {
      _navigator.pop(event.item.name);
    } else if (event is OnPullToRefreshEvent) {
      // TODO: Call repository to fetch data
    }
  }
}

class BalancesItem {
  final String name;
  final String balance;

  BalancesItem(this.name, this.balance);
}

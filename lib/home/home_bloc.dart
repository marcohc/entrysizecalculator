import 'package:binance_api/binance_api.dart';
import 'package:binance_api/model/place_order.dart';
import "package:bloc/bloc.dart";
import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_navigator.dart';

class HomeState {
  HomeState({
    this.balance = 1000,
    this.maxLoss = 20,
    this.entryPrice = 0.0,
    this.stopLoss = 0.0,
    this.entrySize = 0.0,
    this.baseCurrencyPair = "Select currency pair",
  });

  final double balance;
  final double maxLoss;
  final double entryPrice;
  final double stopLoss;
  final double entrySize;
  final String baseCurrencyPair;

  HomeState copyWith({
    double? balance,
    double? maxLoss,
    double? entryPrice,
    double? stopLoss,
    double? entrySize,
    String? baseCurrencyPair,
  }) =>
      HomeState(
        balance: balance ?? this.balance,
        maxLoss: maxLoss ?? this.maxLoss,
        entryPrice: entryPrice ?? this.entryPrice,
        entrySize: entrySize ?? this.entrySize,
        stopLoss: stopLoss ?? this.stopLoss,
        baseCurrencyPair: baseCurrencyPair ?? this.baseCurrencyPair,
      );
}

abstract class HomeEvent {}

class GetBalances extends HomeEvent {}

class PlaceTestOrder extends HomeEvent {}

class OnStopLossSetEvent extends HomeEvent {
  OnStopLossSetEvent(this.stopLoss);

  final String stopLoss;
}

class OnEntryPriceSet extends HomeEvent {
  OnEntryPriceSet(this.entryPrice);

  final String entryPrice;
}

class OnSettingsClickEvent extends HomeEvent {}

class OnBaseCurrencyPairClick extends HomeEvent {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState());

  final _navigator = GetIt.instance.get<AppNavigator>();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is OnStopLossSetEvent) {
      emit(state.copyWith(stopLoss: _parseDouble(event.stopLoss)));
      updateEntrySize();
    } else if (event is OnEntryPriceSet) {
      emit(state.copyWith(entryPrice: _parseDouble(event.entryPrice)));
      updateEntrySize();
    } else if (event is OnSettingsClickEvent) {
      _navigator.showSettingsScreen();
    } else if (event is OnBaseCurrencyPairClick) {
      final symbol = await _navigator.showBalancesScreen();
      if (symbol != null) {
        final pair = await _navigator.showPairsScreen(symbol);
        // await _navigator.showNewOrderScreen(pair);
      }
    } else if (event is GetBalances) {
      await GetIt.instance.get<BinanceApi>().getAllOrders(symbol: 'ETHUSDT');
    } else if (event is PlaceTestOrder) {
      await GetIt.instance.get<BinanceApi>().placeTestOrder(PlaceOrder.marketBuy('ETHBTC', quantity: 0.01));
    }
  }

  void updateEntrySize() {
    if (state.entryPrice != 0.0 && state.stopLoss != 0.0) {
      final entrySize = state.maxLoss / (state.entryPrice - state.stopLoss);
      emit(state.copyWith(entrySize: entrySize));
    }
  }

  double _parseDouble(String value) {
    return double.parse(value);
  }
}

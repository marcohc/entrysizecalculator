import 'package:binance_api/binance_api.dart';
import "package:bloc/bloc.dart";
import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_navigator.dart';

class PairsState {
  PairsState({this.loading = true, this.error = true, this.items});

  final bool loading;
  final bool error;
  final List<String>? items;

  PairsState copyWith({bool loading = true, bool error = true, List<String>? items}) => PairsState(
        loading: loading,
        error: error,
        items: items ?? this.items,
      );
}

abstract class PairsEvent {}

class OnItemClickEvent extends PairsEvent {
  OnItemClickEvent(this.pair);

  final String pair;
}

class OnPullToRefreshEvent extends PairsEvent {}

class InitEvent extends PairsEvent {}

class PairsBloc extends Bloc<PairsEvent, PairsState> {
  PairsBloc(String symbol) : super(PairsState()) {
    add(InitEvent());
  }

  final _navigator = GetIt.instance.get<AppNavigator>();
  final _binanceApi = GetIt.instance.get<BinanceApi>();

  @override
  Stream<PairsState> mapEventToState(PairsEvent event) async* {
    if (event is InitEvent) {
      emit(state.copyWith(items: ['ETHBTC', 'BTCUSDT']));
    } else if (event is OnItemClickEvent) {
      _navigator.pop(event.pair);
    }
  }
}

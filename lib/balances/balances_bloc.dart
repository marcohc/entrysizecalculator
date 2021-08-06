import 'package:binance_api/binance_api.dart';
import "package:bloc/bloc.dart";
import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_navigator.dart';

class BalancesState {
  BalancesState({this.items});

  final List<BalancesItem>? items;

  BalancesState copyWith({List<BalancesItem>? items}) =>
      BalancesState(items: items ?? this.items);
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
      _binanceApi.getAllPairs();
    } else if (event is OnItemClickEvent) {
      _navigator.pop(event.item);
    } else if (event is OnPullToRefreshEvent) {
      // TODO: Call repository to fetch data
    }
  }
}

class BalancesItem {
  final String name;

  BalancesItem(this.name);
}

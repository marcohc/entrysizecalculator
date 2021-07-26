import 'package:binance_api/binance_api.dart';
import "package:bloc/bloc.dart";
import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_navigator.dart';

class SearchState {
  SearchState({this.items});

  final List<SearchItem>? items;

  SearchState copyWith({List<SearchItem>? items}) =>
      SearchState(items: items ?? this.items);
}

abstract class SearchEvent {}

class OnItemClickEvent extends SearchEvent {
  OnItemClickEvent(this.item);

  final SearchItem item;
}

class OnPullToRefreshEvent extends SearchEvent {}

class InitEvent extends SearchEvent {}

// TODO:
// - Show loading first time
// - Display data or empty screen
// - Pull to refresh triggers data again
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState()) {
    add(InitEvent());
  }

  final _navigator = GetIt.instance.get<AppNavigator>();
  final _binanceApi = GetIt.instance.get<BinanceApi>().getAccountSnapshot();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is InitEvent) {
      // TODO: Call repository to fetch data
    } else if (event is OnItemClickEvent) {
      _navigator.pop(event.item);
    } else if (event is OnPullToRefreshEvent) {
      // TODO: Call repository to fetch data
    }
  }
}

class SearchItem {
  final String name;

  SearchItem(this.name);
}

import "package:bloc/bloc.dart";
import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_navigator.dart';

class SearchState {
  SearchState({
    this.balance = 1000,
    this.maxLoss = 20,
    this.entryPrice = 0.0,
    this.stopLoss = 0.0,
    this.entrySize = 0.0,
  });

  final double balance;
  final double maxLoss;
  final double entryPrice;
  final double stopLoss;
  final double entrySize;

  SearchState copyWith({
    double? balance,
    double? maxLoss,
    double? entryPrice,
    double? stopLoss,
    double? entrySize,
  }) =>
      SearchState(
        balance: balance ?? this.balance,
        maxLoss: maxLoss ?? this.maxLoss,
        entryPrice: entryPrice ?? this.entryPrice,
        entrySize: entrySize ?? this.entrySize,
        stopLoss: stopLoss ?? this.stopLoss,
      );
}

abstract class SearchEvent {}

class OnStopLossSetEvent extends SearchEvent {
  OnStopLossSetEvent(this.stopLoss);

  final String stopLoss;
}

class OnEntryPriceSet extends SearchEvent {
  OnEntryPriceSet(this.entryPrice);

  final String entryPrice;
}

class OnSettingsClickEvent extends SearchEvent {}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  final _navigator = GetIt.instance.get<AppNavigator>();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is OnStopLossSetEvent) {
      emit(state.copyWith(stopLoss: _parseDouble(event.stopLoss)));
      updateEntrySize();
    } else if (event is OnEntryPriceSet) {
      emit(state.copyWith(entryPrice: _parseDouble(event.entryPrice)));
      updateEntrySize();
    } else if (event is OnSettingsClickEvent) {
      _navigator.showSettingsScreen();
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

import 'package:bloc/bloc.dart';

class HomeState {
  HomeState({this.balance = 0.0, this.maxLoss = 0.0, this.entryPrice = 0.0, this.stopLoss = 0.0, this.entrySize = 0.0});

  final double balance;
  final double maxLoss;
  final double entryPrice;
  final double stopLoss;
  final double entrySize;
}

abstract class HomeEvent {}

class OnStopLossSetEvent extends HomeEvent {
  OnStopLossSetEvent(this.stopLoss);

  final double stopLoss;
}

class OnEntryPriceSet extends HomeEvent {
  OnEntryPriceSet(this.entryPrice);

  final double entryPrice;
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is OnStopLossSetEvent) {
    } else if (event is OnEntryPriceSet) {}
  }
}

import "package:bloc/bloc.dart";

class NewOrderState {
  NewOrderState({this.loading = true, this.error = true, required this.pair});

  final bool loading;
  final bool error;
  final String pair;

  NewOrderState copyWith({bool loading = true, bool error = true, String? pair}) => NewOrderState(
        loading: loading,
        error: error,
        pair: pair ?? this.pair,
      );
}

abstract class NewOrderEvent {}

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {
  NewOrderBloc(String pair) : super(NewOrderState(pair: pair));

  @override
  Stream<NewOrderState> mapEventToState(NewOrderEvent event) async* {}
}

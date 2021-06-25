import "package:bloc/bloc.dart";

class SettingsState {
  SettingsState({
    this.binanceApiKey = "",
    this.risk = "",
  });

  final String binanceApiKey;
  final String risk;
}

abstract class SettingsEvent {}

class OnSettingsClickEvent extends SettingsEvent {}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {

  }
}

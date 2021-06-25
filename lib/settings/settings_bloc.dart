import "package:bloc/bloc.dart";
import "package:shared_preferences/shared_preferences.dart";

class SettingsState {
  SettingsState({
    this.binanceApiKey = "",
    this.risk = 0.0,
  });

  final String binanceApiKey;
  final double risk;

  SettingsState copyWith({
    String? binanceApiKey,
    double? risk,
  }) =>
      SettingsState(
        binanceApiKey: binanceApiKey ?? this.binanceApiKey,
        risk: risk ?? this.risk,
      );
}

abstract class SettingsEvent {}

class InitEvent extends SettingsEvent {}

class OnBinanceApiKey extends SettingsEvent {
  OnBinanceApiKey(this.text);

  final String text;
}

class OnRiskApiKey extends SettingsEvent {
  OnRiskApiKey(this.text);

  final String text;
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState()) {
    add(InitEvent());
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is InitEvent) {
      emit(state.copyWith(
        binanceApiKey: await _getBinanceApiKey(),
        risk: await _getRisk(),
      ));
    } else if (event is OnBinanceApiKey) {
      _setBinanceApiKey(event.text);
    } else if (event is OnRiskApiKey) {
      _setRisk(double.parse(event.text));
    }
  }

  Future<String?> _getBinanceApiKey() async {
    return (await getSharedPreferences()).getString("binanceApiKey");
  }

  Future<double?> _getRisk() async {
    return (await getSharedPreferences()).getDouble("risk");
  }

  void _setBinanceApiKey(String text) async {
    (await getSharedPreferences()).setString('binanceApiKey', text);
  }

  void _setRisk(double value) async {
    (await getSharedPreferences()).setDouble('risk', value);
  }

  Future<SharedPreferences> getSharedPreferences() async =>
      await SharedPreferences.getInstance();
}

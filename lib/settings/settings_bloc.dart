import "package:bloc/bloc.dart";
import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_prefs.dart';

class SettingsState {
  SettingsState({
    this.binanceApiKey = "",
    this.binanceSecret = "",
    this.risk = 0.0,
  });

  final String binanceApiKey;
  final String binanceSecret;
  final double risk;

  SettingsState copyWith({
    String? binanceApiKey,
    String? binanceSecret,
    double? risk,
  }) =>
      SettingsState(
        binanceApiKey: binanceApiKey ?? this.binanceApiKey,
        binanceSecret: binanceSecret ?? this.binanceSecret,
        risk: risk ?? this.risk,
      );
}

abstract class SettingsEvent {}

class InitEvent extends SettingsEvent {}

class OnBinanceApiKey extends SettingsEvent {
  OnBinanceApiKey(this.text);

  final String text;
}

class OnBinanceSecret extends SettingsEvent {
  OnBinanceSecret(this.text);

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

  final appPrefs = GetIt.instance.get<AppPrefs>();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is InitEvent) {
      emit(state.copyWith(
        binanceApiKey: appPrefs.getBinanceApiKey(),
        binanceSecret: appPrefs.getBinanceSecret(),
        risk: appPrefs.getRisk(),
      ));
    } else if (event is OnBinanceApiKey) {
      appPrefs.storeBinanceApiKey(event.text);
    } else if (event is OnBinanceSecret) {
      appPrefs.storeBinanceSecret(event.text);
    } else if (event is OnRiskApiKey) {
      double? risk = double.tryParse(event.text);
      if (risk != null) {
        appPrefs.storeRisk(risk);
      }
    }
  }
}

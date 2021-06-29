import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void storeBinanceApiKey(String value) {
    _prefs.setString('binance_api_key', value);
  }

  String? getBinanceApiKey() => _prefs.getString('binance_api_key');

  void storeBinanceSecret(String value) {
    _prefs.setString('binance_secret', value);
  }

  String? getBinanceSecret() => _prefs.getString('binance_secret');

  void storeRisk(double value) {
    _prefs.setDouble('risk', value);
  }

  double? getRisk() => _prefs.getDouble('risk');
}

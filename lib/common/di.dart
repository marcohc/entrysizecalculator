import 'package:binance_api/binance_api.dart';
import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_navigator.dart';
import 'package:tilda/common/app_prefs.dart';

class DiModule {
  static Future<void> setup() async {
    final getIt = GetIt.instance;
    final appPrefs = AppPrefs();
    await appPrefs.init();

    getIt
      ..registerSingleton(AppNavigator())
      ..registerFactory(() => BinanceApi(apiKey: appPrefs.getBinanceApiKey() ?? '', secret: appPrefs.getBinanceSecret() ?? ''))
      ..registerSingleton(appPrefs);
  }
}

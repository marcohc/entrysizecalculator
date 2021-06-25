import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_navigator.dart';

class DiModule {
  static Future<void> setup() async {
    final getIt = GetIt.instance;
    // final sharedPreferences = await SharedPreferences.getInstance();

    getIt..registerSingleton(AppNavigator())
        // ..registerSingleton(sharedPreferences)
        ;
  }
}

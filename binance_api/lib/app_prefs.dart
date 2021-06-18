import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void storeTimeAdjustment(int timeAdjustment) {
    _prefs.setInt('time_adj', timeAdjustment);
  }

  static int getTimeAdjustment() => _prefs.get('time_adj') as int? ?? 0;
}

import 'package:flutter/widgets.dart';

class AppNavigator {
  static const String home = '/';
  static const String settings = '/settings';

  final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => navigatorKey.currentState!;

  void pop<T extends Object?>([T? result]) => _navigator.pop(result);

  void showHomeScreen() {
    _navigator.pushNamedAndRemoveUntil(AppNavigator.home, (route) => false);
  }

  void showSettingsScreen() {
    _navigator.pushNamed(AppNavigator.settings);
  }
}

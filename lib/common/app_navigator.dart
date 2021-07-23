import 'package:flutter/widgets.dart';

class AppNavigator {
  static const String home = '/';
  static const String settings = '/settings';
  static const String search = '/search';

  final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => navigatorKey.currentState!;

  void pop<T extends Object?>([T? result]) => _navigator.pop(result);

  void showHomeScreen() {
    _navigator.pushNamedAndRemoveUntil(AppNavigator.home, (route) => false);
  }

  void showSettingsScreen() {
    _navigator.pushNamed(AppNavigator.settings);
  }

  void showCurrencyPairSearchScreen() {
    _navigator.pushNamed(AppNavigator.search);
  }
}

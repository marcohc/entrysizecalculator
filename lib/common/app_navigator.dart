import 'package:flutter/widgets.dart';

class AppNavigator {
  static const String home = '/';
  static const String settings = '/settings';
  static const String balances = '/balances';
  static const String pairs = '/pairs';
  static const String newOrder = '/newOrder';

  final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => navigatorKey.currentState!;

  void pop<T extends Object?>([T? result]) => _navigator.pop(result);

  void showHomeScreen() {
    _navigator.pushNamedAndRemoveUntil(AppNavigator.home, (route) => false);
  }

  void showSettingsScreen() {
    _navigator.pushNamed(AppNavigator.settings);
  }

  Future<String?> showBalancesScreen() async => (await _navigator.pushNamed(AppNavigator.balances)) as String?;

  Future<String?> showPairsScreen(String symbol) async {
    var result = await _navigator.pushNamed(AppNavigator.pairs, arguments: symbol);
    return result as String?;
  }

  void showNewOrderScreen(String pair) {
    _navigator.pushNamed(AppNavigator.newOrder);
  }
}

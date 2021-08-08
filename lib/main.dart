import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tilda/common/app_navigator.dart';
import 'package:tilda/common/di.dart';
import 'package:tilda/home/home_screen.dart';
import 'package:tilda/balances/balances_screen.dart';
import 'package:tilda/pairs/pairs_screen.dart';
import 'package:tilda/settings/settings_screen.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await DiModule.setup();
      runApp(MyApp());
    },
    (error, st) => print(error),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tilda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: GetIt.instance.get<AppNavigator>().navigatorKey,
      initialRoute: AppNavigator.home,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppNavigator.home:
        return MaterialPageRoute<void>(
          builder: (context) => HomeScreen(),
          settings: settings,
        );
      case AppNavigator.settings:
        return MaterialPageRoute<void>(
          builder: (context) => SettingsScreen(),
          settings: settings,
        );
      case AppNavigator.balances:
        return MaterialPageRoute<void>(
          builder: (context) => BalancesScreen(),
          settings: settings,
        );
      case AppNavigator.pairs:
        return MaterialPageRoute<void>(
          builder: (context) {
            return PairsScreen(symbol: settings.arguments as String);
          },
          settings: settings,
        );
      case AppNavigator.newOrder:
        return MaterialPageRoute<void>(
          builder: (context) => BalancesScreen(),
          settings: settings,
        );
    }
  }
}

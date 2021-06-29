import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilda/home/home_bloc.dart';
import 'package:tilda/settings/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _bloc = SettingsBloc();

  late final _riskController = TextEditingController()
    ..addListener(() {
      _bloc.add(OnRiskApiKey(_riskController.text));
    });
  late final _binanceApiKeyController = TextEditingController()
    ..addListener(() {
      _bloc.add(OnBinanceApiKey(_binanceApiKeyController.text));
    });
  late final _binanceSecretController = TextEditingController()
    ..addListener(() {
      _bloc.add(OnBinanceSecret(_binanceSecretController.text));
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: _bloc,
        builder: (context, state) {

          _riskController.text = state.risk.toString();
          _binanceApiKeyController.text = state.binanceApiKey;
          _binanceSecretController.text = state.binanceSecret;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Risk tolerance:"),
                  keyboardType: TextInputType.number,
                  controller: _riskController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Binance API key:"),
                  keyboardType: TextInputType.text,
                  controller: _binanceApiKeyController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Binance Secret:"),
                  keyboardType: TextInputType.text,
                  controller: _binanceSecretController,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

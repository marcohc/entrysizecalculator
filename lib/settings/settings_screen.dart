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

  final _riskController = TextEditingController();
  final _binanceApiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _riskController.addListener(() {
      // _bloc.add(OnStopLossSetEvent(_binanceApiKeyController.text));
    });

    _binanceApiKeyController.addListener(() {
      // _bloc.add(OnStopLossSetEvent(_binanceApiKeyController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
          bloc: _bloc,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                TextField(
                  decoration: InputDecoration(labelText: "Risk tolerance:"),
                  keyboardType: TextInputType.number,
                  controller: _riskController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Binance API key:"),
                  keyboardType: TextInputType.number,
                  controller: _binanceApiKeyController,
                ),
              ]),
            );
          }),
    );
  }
}

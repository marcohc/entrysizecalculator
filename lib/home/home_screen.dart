import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilda/home/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = HomeBloc();

  final _entryPriceController = TextEditingController();
  final _stopLossController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _entryPriceController.addListener(() {
      _bloc.add(OnEntryPriceSet(_entryPriceController.text));
    });

    _stopLossController.addListener(() {
      _bloc.add(OnStopLossSetEvent(_stopLossController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
          bloc: _bloc,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Text(
                  "Balance: " + state.balance.toString(),
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  "Max loss: " + state.maxLoss.toString(),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Entry price"),
                  keyboardType: TextInputType.number,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter(r'(^\d*\.?\d*)', allow: false)
                  // ],
                  controller: _entryPriceController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Stop loss"),
                  keyboardType: TextInputType.number,
                  controller: _stopLossController,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Entry size: " + state.entrySize.toString(),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ]),
            );
          }),
    );
  }
}

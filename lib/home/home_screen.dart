import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilda/home/home_bloc.dart';
import 'package:tilda/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = HomeBloc();

  final _stopLossController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _stopLossController.addListener(() {
      _bloc.add(OnStopLossSetEvent(_stopLossController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => _bloc.add(OnSettingsClickEvent()),
                child: Icon(Icons.settings),
              ))
        ],
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
                TextInputWidget(
                  labelText: "Entry price",
                  keyboardType: TextInputType.number,
                  onTextChanged: (text) => _bloc.add(OnEntryPriceSet(text)),
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

// TODO: Research better way to pass text function
class TextInputWidget extends StatefulWidget {
  const TextInputWidget({
    required this.labelText,
    required this.keyboardType,
    required this.onTextChanged,
  });

  final String labelText;
  final TextInputType keyboardType;
  final Function(String) onTextChanged;

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      widget.onTextChanged(_textEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: widget.labelText),
      keyboardType: widget.keyboardType,
      controller: _textEditingController,
    );
  }
}

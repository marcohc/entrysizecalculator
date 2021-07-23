import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilda/search/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _bloc = SearchBloc();

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
        title: Text("Search"),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
          bloc: _bloc,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
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

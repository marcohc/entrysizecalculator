import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilda/new_order/new_order_bloc.dart';

class NewOrderScreen extends StatefulWidget {
  NewOrderScreen({Key? key, required this.pair}) : super(key: key);
  final String pair;

  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  late var _bloc = NewOrderBloc(widget.pair);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NewOrder"),
      ),
      body: BlocBuilder<NewOrderBloc, NewOrderState>(
        bloc: _bloc,
        builder: (context, state) => Center(
          child: Card(
            elevation: 4,
            child: Text('DO IT! ${state.pair}'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilda/pairs/pairs_bloc.dart';

class PairsScreen extends StatefulWidget {
  PairsScreen({Key? key, required this.symbol}) : super(key: key);
  final String symbol;

  @override
  _PairsScreenState createState() => _PairsScreenState();
}

class _PairsScreenState extends State<PairsScreen> {
  late var _bloc = PairsBloc(widget.symbol);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pairs"),
      ),
      body: BlocBuilder<PairsBloc, PairsState>(
        bloc: _bloc,
        builder: (context, state) => Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.items?.length ?? 0,
            itemBuilder: (context, index) => state.items != null
                ? OutlinedButton(
                    child: Text(state.items![index]),
                    onPressed: () => _bloc.add(
                      OnItemClickEvent(state.items![index]),
                    ),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}

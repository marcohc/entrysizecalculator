import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilda/balances/balances_bloc.dart';

class BalancesScreen extends StatefulWidget {
  BalancesScreen({Key? key}) : super(key: key);

  @override
  _BalancesScreenState createState() => _BalancesScreenState();
}

class _BalancesScreenState extends State<BalancesScreen> {
  final _bloc = BalancesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balances"),
      ),
      body: BlocBuilder<BalancesBloc, BalancesState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state.loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return RefreshIndicator(
              child: state.items == null
                  ? Container(
                      child: ListView(
                        children: [
                          Center(
                            child: Text(
                              "Pull to refresh to get data.",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.items!.length,
                            itemBuilder: (context, index) {
                              final item = state.items![index];
                              return InkWell(
                                onTap: () {
                                  _bloc.add(OnItemClickEvent(item));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(item.name)),
                                          Text(item.balance)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              onRefresh: () async {
                _bloc.add(OnPullToRefreshEvent());
              },
            );
          }
        },
      ),
    );
  }
}

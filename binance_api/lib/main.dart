import 'package:binance_api/binance_api.dart';

void main() {
  _loadSomeStuff();
}

Future<void> _loadSomeStuff() async {
  final api = BinanceApi();
  final serverTime = await api.getServerTime();
  print('Status: $serverTime');
}

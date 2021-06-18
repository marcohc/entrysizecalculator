import 'package:binance_api/binance_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final api = BinanceApi();
    final serverTime = await api.getServerTime();
    print('Status: $serverTime');
  });
}

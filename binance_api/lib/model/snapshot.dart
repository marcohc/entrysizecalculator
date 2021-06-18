import 'package:binance_api/model/account_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'snapshot.freezed.dart';
part 'snapshot.g.dart';

@freezed
abstract class Snapshot with _$Snapshot {
const Snapshot._();

const factory Snapshot({
  required List<Balance> balance,
  required String type,
  required int updateTime,
}) = _Snapshot;

factory Snapshot.fromJson(Map<String, dynamic> json) => _$SnapshotFromJson(json);

}

// "snapshotVos":[
// {
// "data":{
// "Snapshots":[
// {
// "asset":"BTC",
// "free":"0.09905021",
// "locked":"0.00000000"
// },
// {
// "asset":"USDT",
// "free":"1.89109409",
// "locked":"0.00000000"
// }
// ],
// "totalAssetOfBtc":"0.09942700"
// },
// "type":"spot",
// "updateTime":1576281599000
// }
// ]
//

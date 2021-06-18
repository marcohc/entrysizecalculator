import 'package:freezed_annotation/freezed_annotation.dart';

part 'error.freezed.dart';

@freezed
class ErrorModel {

  const factory ErrorModel.network() = ErrorModelNetwork;
  const factory ErrorModel.server() = ErrorModelServer;
  const factory ErrorModel.unexpected() = ErrorModelUnexpected;

}

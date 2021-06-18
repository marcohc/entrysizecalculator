// import 'dart:core';
//
// import 'package:dio/dio.dart';
// import 'package:either_option/either_option.dart';
// import 'package:tilda/common/api/model/error.dart';
//
// Future<Either<ErrorModel, T>> executeSafely<R, T>(String tag, Future<R> networkRequest, T Function(R) converter) async {
//   try {
//     final result = await networkRequest;
//     return Right(converter(result));
//   } on DioError catch (error, st) {
//     return Left(ErrorModel.network());
//     // if (error.code == 14) {
//     //   return Left(NetworkErrorModel());
//     // } else {
//     //   Log.e(tag, 'Grpc error', error, st);
//     //   return Left(error.toServerErrorModel());
//     // }
//   } catch (error, st) {
//     return Left(ErrorModel.unexpected());
//   }
// }

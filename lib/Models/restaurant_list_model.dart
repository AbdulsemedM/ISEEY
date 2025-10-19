import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iseey/Models/restaurant_data.dart';
import 'package:iseey/Models/restaurant_list_result.dart';

part 'restaurant_list_model.freezed.dart';
part 'restaurant_list_model.g.dart';

@freezed
class RestaurantListModel with _$RestaurantListModel {
  const factory RestaurantListModel({
    required bool success,
    required String message,
    @Default(RestaurantData()) RestaurantData data,
  }) = _RestaurantListModel;

  // factory RestaurantListModel.fromJson(Map<String, dynamic> json) {
  //   log("EXCEPTION papa===>  ${json['data']}");

  //   return RestaurantListModel(
  //     success: json['success'] as bool,
  //     message: json['message'] as String,
  //     result: (json['data']?['restaurants'] as List<dynamic>? ?? [])
  //         .map((e) => RestaurantListResult.fromJson(e as Map<String, dynamic>))
  //         .toList(),
  //   );
  // }

  factory RestaurantListModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantListModelFromJson(json);
}

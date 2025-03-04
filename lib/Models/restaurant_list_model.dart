import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iseey/Models/restaurant_list_result.dart';

part 'restaurant_list_model.freezed.dart';
part 'restaurant_list_model.g.dart';

@freezed
class RestaurantListModel with _$RestaurantListModel {
  const factory RestaurantListModel({
    required bool success,
    required String message,
    required List<RestaurantListResult> result,
  }) = _RestaurantListModel;

  factory RestaurantListModel.fromJson(Map<String, dynamic> json) {
    final model = _$RestaurantListModelFromJson({
      ...json,
      'result': (json['data']?['restaurants'] ?? []) as List<dynamic>,
    });

    return model;
  }
}

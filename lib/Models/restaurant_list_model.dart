import 'package:ISEEY/Models/restaurant_list_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant_list_model.freezed.dart';
part 'restaurant_list_model.g.dart';

@freezed
class RestaurantListModel with _$RestaurantListModel {
  const factory RestaurantListModel({
    required int success,
    required String message,
    required List<RestaurantListResult> result,
  }) = _RestaurantListModel;

  factory RestaurantListModel.fromJson(Map<String, dynamic> json) => _$RestaurantListModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iseey/Models/restaurant_list_result.dart';

part 'restaurant_data.freezed.dart';
part 'restaurant_data.g.dart';

@freezed
class RestaurantData with _$RestaurantData {
 const factory RestaurantData({
    @Default([]) List<RestaurantListResult> restaurants,
  }) = _RestaurantData;

  factory RestaurantData.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDataFromJson(json);
}

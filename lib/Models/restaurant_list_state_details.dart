import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant_list_state_details.freezed.dart';
part 'restaurant_list_state_details.g.dart';

@freezed
class RestaurantListStateDetails with _$RestaurantListStateDetails {
  const factory RestaurantListStateDetails({
    required String sId,
    required int id,
    required String name,
  }) = _RestaurantListStateDetails;

  factory RestaurantListStateDetails.fromJson(Map<String, dynamic> json) => _$RestaurantListStateDetailsFromJson(json);
}

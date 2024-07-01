// ignore_for_file: invalid_annotation_target

import 'package:ISEEY/Models/google_review.dart';
import 'package:ISEEY/Models/restaurant_image.dart';
import 'package:ISEEY/Models/restaurant_list_state_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant_list_result.freezed.dart';
part 'restaurant_list_result.g.dart';

@freezed
class RestaurantListResult with _$RestaurantListResult {
  const factory RestaurantListResult({
    @JsonKey(name: '_id') required String sId,
    @JsonKey(name: 'email_verified') required String emailVerified,
    @JsonKey(name: 'image') required String logo,
    @JsonKey(name: 'lat') required double lat,
    @JsonKey(name: 'lng') required double lng,
    @JsonKey(name: 'active') required String active,
    @JsonKey(name: 'deleted') required String deleted,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'phoneNumber') required String phoneNumber,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'updated') required int updated,
    @JsonKey(name: 'created') required int created,
    @JsonKey(name: 'number_of_tables') required int numberOfTables,
    @JsonKey(name: 'address') required String address,
    @JsonKey(name: 'menu_type') required String menuType,
    @JsonKey(name: 'drink_menu_type') String? drinkMenuType,
    @JsonKey(name: 'menu') String? menu,
    @JsonKey(name: 'drinkMenu') String? drinkMenu,
    @JsonKey(name: 'place_id') String? googlePageUrl,
    @JsonKey(name: 'restaurant_image') RestaurantImage? restaurantImage,
    @JsonKey(name: 'restaurantReviewCount') int? reviewsCount,
    @Default(0) int checkedInCount,
    required String bio,
    required bool newsletter,
    @Default(0.0) double ratings,
    int? stateExists,
    int? cityExists,
    int? countryDetails,
    String? city,
    String? state,
    String? country,
    String? facebook,
    String? instagram,
    String? website,
    RestaurantListStateDetails? stateDetails,
    RestaurantListStateDetails? cityDetails,
    @Default([]) List<GoogleReview> reviews,
  }) = _RestaurantListResult;

  factory RestaurantListResult.fromJson(Map<String, dynamic> json) {
    final model = _$RestaurantListResultFromJson(json);
    return model.googlePageUrl == null
        ? model
        : model.copyWith(
            googlePageUrl:
                "https://www.google.com/maps/search/?api=1&query=${model.lat},${model.lng}&query_place_id=${model.googlePageUrl}",
          );
  }
}

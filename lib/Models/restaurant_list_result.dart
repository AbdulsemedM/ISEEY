// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iseey/Models/google_rating_model.dart';
import 'package:iseey/Models/google_review.dart';
import 'package:iseey/Models/restaurant_image.dart';
import 'package:iseey/Models/restaurant_list_state_details.dart';

part 'restaurant_list_result.freezed.dart';
part 'restaurant_list_result.g.dart';

@freezed
class RestaurantListResult with _$RestaurantListResult {
  const factory RestaurantListResult({
    @JsonKey(name: '_id') required String sId,
    @JsonKey(name: 'email_verified') required String emailVerified,
    @JsonKey(name: 'image') @Default('') String? logo,
    @JsonKey(name: 'lat') required double lat,
    @JsonKey(name: 'lng') required double lng,
    @JsonKey(name: 'active') required String active,
    @JsonKey(name: 'deleted') required String deleted,
    @JsonKey(name: 'name') required String name,
    @Default('') String phoneNumber,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'updated') int? updated,
    @JsonKey(name: 'created') int? created,
    @JsonKey(name: 'number_of_tables') required int numberOfTables,
    @JsonKey(name: 'address') required String address,
    @JsonKey(name: 'menu_type') String? menuType,
    @JsonKey(name: 'drink_menu_type') String? drinkMenuType,
    @JsonKey(name: 'menu') String? menu,
    @JsonKey(name: 'drinkMenu') String? drinkMenu,
    @JsonKey(name: 'place_id') String? googlePageUrl,
    @JsonKey(name: 'restaurant_image') RestaurantImage? restaurantImage,
    @JsonKey(name: 'restaurantReviewCount') int? reviewsCount,
    @JsonKey(name: 'checked_in_count') @Default(0) int checkedInCount,
    @Default("") String bio,
    @Default(false) bool newsletter,
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
    @JsonKey(name: 'google_rating') @Default(GoogleRatingModel()) GoogleRatingModel googleRating,
  }) = _RestaurantListResult;

  // factory RestaurantListResult.fromJson(Map<String, dynamic> json) {
  //   final model = _$RestaurantListResultFromJson(json);
  //   return model.googlePageUrl == null
  //       ? model
  //       : model.copyWith(
  //           googlePageUrl:
  //               "https://www.google.com/maps/search/?api=1&query=${model.lat},${model.lng}&query_place_id=${model.googlePageUrl}",
  //         );
  // }
  factory RestaurantListResult.fromJson(Map<String, dynamic> json) =>
      _$RestaurantListResultFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_rating_model.freezed.dart';
part 'google_rating_model.g.dart';

@freezed
class GoogleRatingModel with _$GoogleRatingModel {
 const factory GoogleRatingModel({
    @Default(0.0) double overall,
    @JsonKey(name: 'total_ratings') @Default(0) int totalRatings,
    @JsonKey(name: 'last_updated') @Default("") String lastUpdated,
  }) = _GoogleRatingModel;

  factory GoogleRatingModel.fromJson(Map<String, dynamic> json) =>
      _$GoogleRatingModelFromJson(json);
}

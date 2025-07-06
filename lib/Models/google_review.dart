// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_review.freezed.dart';
part 'google_review.g.dart';

@freezed
class GoogleReview with _$GoogleReview {
  const factory GoogleReview({
    @JsonKey(name: 'author_name') required String authorName,
    required int rating,
    required String text,
  }) = _GoogleReview;

  factory GoogleReview.fromJson(Map<String, dynamic> json) => _$GoogleReviewFromJson(json);
}

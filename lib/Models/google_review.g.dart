// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoogleReviewImpl _$$GoogleReviewImplFromJson(Map<String, dynamic> json) =>
    _$GoogleReviewImpl(
      authorName: json['author_name'] as String,
      rating: (json['rating'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$$GoogleReviewImplToJson(_$GoogleReviewImpl instance) =>
    <String, dynamic>{
      'author_name': instance.authorName,
      'rating': instance.rating,
      'text': instance.text,
    };

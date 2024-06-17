// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantListModelImpl _$$RestaurantListModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RestaurantListModelImpl(
      success: (json['success'] as num).toInt(),
      message: json['message'] as String,
      result: (json['result'] as List<dynamic>)
          .map((e) => RestaurantListResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RestaurantListModelImplToJson(
        _$RestaurantListModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'result': instance.result,
    };

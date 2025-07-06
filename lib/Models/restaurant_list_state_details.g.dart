// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_list_state_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantListStateDetailsImpl _$$RestaurantListStateDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$RestaurantListStateDetailsImpl(
      sId: json['sId'] as String,
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$RestaurantListStateDetailsImplToJson(
        _$RestaurantListStateDetailsImpl instance) =>
    <String, dynamic>{
      'sId': instance.sId,
      'id': instance.id,
      'name': instance.name,
    };

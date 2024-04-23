// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantImageImpl _$$RestaurantImageImplFromJson(
        Map<String, dynamic> json) =>
    _$RestaurantImageImpl(
      source: $enumDecode(_$RestaurantImageSourceEnumMap, json['source']),
      location: json['location'] as String,
    );

Map<String, dynamic> _$$RestaurantImageImplToJson(
        _$RestaurantImageImpl instance) =>
    <String, dynamic>{
      'source': _$RestaurantImageSourceEnumMap[instance.source]!,
      'location': instance.location,
    };

const _$RestaurantImageSourceEnumMap = {
  RestaurantImageSource.local: 'local',
  RestaurantImageSource.google: 'google',
};

// ignore_for_file: invalid_annotation_target

import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant_image.freezed.dart';
part 'restaurant_image.g.dart';

@freezed
class RestaurantImage with _$RestaurantImage {
  const factory RestaurantImage({
    required RestaurantImageSource source,
    required String location,
  }) = _RestaurantImage;

  factory RestaurantImage.fromJson(Map<String, dynamic> json) => _$RestaurantImageFromJson(json); 
    
    // final model = 

    // return model.source == RestaurantImageSource.local
    //     ? model
    //     : model.copyWith(
    //         location: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${model.location}&key=$googleApiKey",
    //       );
  
}

enum RestaurantImageSource { local, google }

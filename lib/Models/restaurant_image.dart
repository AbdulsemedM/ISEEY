import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';

part 'restaurant_image.freezed.dart';
part 'restaurant_image.g.dart';

// ignore_for_file: invalid_annotation_target
@freezed
class RestaurantImage with _$RestaurantImage {
  const factory RestaurantImage({
    required RestaurantImageSource source,
    required String? location,
  }) = _RestaurantImage;

  factory RestaurantImage.fromJson(Map<String, dynamic> json) {
    final model = _$RestaurantImageFromJson(json);

    return model.source == RestaurantImageSource.local
        ? model
        : model.copyWith(
            location:
                "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${model.location}&key=$googleApiKey",
          );
  }
}

enum RestaurantImageSource { local, google }

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantListResultImpl _$$RestaurantListResultImplFromJson(
        Map<String, dynamic> json) =>
    _$RestaurantListResultImpl(
      sId: json['_id'] as String,
      emailVerified: json['email_verified'] as String,
      logo: json['image'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      active: json['active'] as String,
      deleted: json['deleted'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      updated: (json['updated'] as num?)?.toInt(),
      created: (json['created'] as num?)?.toInt(),
      numberOfTables: (json['number_of_tables'] as num).toInt(),
      address: json['address'] as String,
      menuType: json['menu_type'] as String?,
      drinkMenuType: json['drink_menu_type'] as String?,
      menu: json['menu'] as String?,
      drinkMenu: json['drinkMenu'] as String?,
      googlePageUrl: json['place_id'] as String?,
      restaurantImage: json['restaurant_image'] == null
          ? null
          : RestaurantImage.fromJson(
              json['restaurant_image'] as Map<String, dynamic>),
      reviewsCount: (json['restaurantReviewCount'] as num?)?.toInt(),
      checkedInCount: (json['checkedInCount'] as num?)?.toInt() ?? 0,
      bio: json['bio'] as String,
      newsletter: json['newsletter'] as bool,
      ratings: (json['ratings'] as num?)?.toDouble() ?? 0.0,
      stateExists: (json['stateExists'] as num?)?.toInt(),
      cityExists: (json['cityExists'] as num?)?.toInt(),
      countryDetails: (json['countryDetails'] as num?)?.toInt(),
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      website: json['website'] as String?,
      stateDetails: json['stateDetails'] == null
          ? null
          : RestaurantListStateDetails.fromJson(
              json['stateDetails'] as Map<String, dynamic>),
      cityDetails: json['cityDetails'] == null
          ? null
          : RestaurantListStateDetails.fromJson(
              json['cityDetails'] as Map<String, dynamic>),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => GoogleReview.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RestaurantListResultImplToJson(
        _$RestaurantListResultImpl instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'email_verified': instance.emailVerified,
      'image': instance.logo,
      'lat': instance.lat,
      'lng': instance.lng,
      'active': instance.active,
      'deleted': instance.deleted,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'updated': instance.updated,
      'created': instance.created,
      'number_of_tables': instance.numberOfTables,
      'address': instance.address,
      'menu_type': instance.menuType,
      'drink_menu_type': instance.drinkMenuType,
      'menu': instance.menu,
      'drinkMenu': instance.drinkMenu,
      'place_id': instance.googlePageUrl,
      'restaurant_image': instance.restaurantImage,
      'restaurantReviewCount': instance.reviewsCount,
      'checkedInCount': instance.checkedInCount,
      'bio': instance.bio,
      'newsletter': instance.newsletter,
      'ratings': instance.ratings,
      'stateExists': instance.stateExists,
      'cityExists': instance.cityExists,
      'countryDetails': instance.countryDetails,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'website': instance.website,
      'stateDetails': instance.stateDetails,
      'cityDetails': instance.cityDetails,
      'reviews': instance.reviews,
    };

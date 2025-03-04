// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_list_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RestaurantListResult _$RestaurantListResultFromJson(Map<String, dynamic> json) {
  return _RestaurantListResult.fromJson(json);
}

/// @nodoc
mixin _$RestaurantListResult {
  @JsonKey(name: '_id')
  String get sId => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_verified')
  String get emailVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  String get logo => throw _privateConstructorUsedError;
  @JsonKey(name: 'lat')
  double get lat => throw _privateConstructorUsedError;
  @JsonKey(name: 'lng')
  double get lng => throw _privateConstructorUsedError;
  @JsonKey(name: 'active')
  String get active => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted')
  String get deleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'phoneNumber')
  String get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  int? get updated => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  int? get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'number_of_tables')
  int get numberOfTables => throw _privateConstructorUsedError;
  @JsonKey(name: 'address')
  String get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'menu_type')
  String? get menuType => throw _privateConstructorUsedError;
  @JsonKey(name: 'drink_menu_type')
  String? get drinkMenuType => throw _privateConstructorUsedError;
  @JsonKey(name: 'menu')
  String? get menu => throw _privateConstructorUsedError;
  @JsonKey(name: 'drinkMenu')
  String? get drinkMenu => throw _privateConstructorUsedError;
  @JsonKey(name: 'place_id')
  String? get googlePageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'restaurant_image')
  RestaurantImage? get restaurantImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'restaurantReviewCount')
  int? get reviewsCount => throw _privateConstructorUsedError;
  int get checkedInCount => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  bool get newsletter => throw _privateConstructorUsedError;
  double get ratings => throw _privateConstructorUsedError;
  int? get stateExists => throw _privateConstructorUsedError;
  int? get cityExists => throw _privateConstructorUsedError;
  int? get countryDetails => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get facebook => throw _privateConstructorUsedError;
  String? get instagram => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  RestaurantListStateDetails? get stateDetails =>
      throw _privateConstructorUsedError;
  RestaurantListStateDetails? get cityDetails =>
      throw _privateConstructorUsedError;
  List<GoogleReview> get reviews => throw _privateConstructorUsedError;

  /// Serializes this RestaurantListResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantListResultCopyWith<RestaurantListResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantListResultCopyWith<$Res> {
  factory $RestaurantListResultCopyWith(RestaurantListResult value,
          $Res Function(RestaurantListResult) then) =
      _$RestaurantListResultCopyWithImpl<$Res, RestaurantListResult>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String sId,
      @JsonKey(name: 'email_verified') String emailVerified,
      @JsonKey(name: 'image') String logo,
      @JsonKey(name: 'lat') double lat,
      @JsonKey(name: 'lng') double lng,
      @JsonKey(name: 'active') String active,
      @JsonKey(name: 'deleted') String deleted,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'phoneNumber') String phoneNumber,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'updated') int? updated,
      @JsonKey(name: 'created') int? created,
      @JsonKey(name: 'number_of_tables') int numberOfTables,
      @JsonKey(name: 'address') String address,
      @JsonKey(name: 'menu_type') String? menuType,
      @JsonKey(name: 'drink_menu_type') String? drinkMenuType,
      @JsonKey(name: 'menu') String? menu,
      @JsonKey(name: 'drinkMenu') String? drinkMenu,
      @JsonKey(name: 'place_id') String? googlePageUrl,
      @JsonKey(name: 'restaurant_image') RestaurantImage? restaurantImage,
      @JsonKey(name: 'restaurantReviewCount') int? reviewsCount,
      int checkedInCount,
      String bio,
      bool newsletter,
      double ratings,
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
      List<GoogleReview> reviews});

  $RestaurantImageCopyWith<$Res>? get restaurantImage;
  $RestaurantListStateDetailsCopyWith<$Res>? get stateDetails;
  $RestaurantListStateDetailsCopyWith<$Res>? get cityDetails;
}

/// @nodoc
class _$RestaurantListResultCopyWithImpl<$Res,
        $Val extends RestaurantListResult>
    implements $RestaurantListResultCopyWith<$Res> {
  _$RestaurantListResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sId = null,
    Object? emailVerified = null,
    Object? logo = null,
    Object? lat = null,
    Object? lng = null,
    Object? active = null,
    Object? deleted = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? email = null,
    Object? updated = freezed,
    Object? created = freezed,
    Object? numberOfTables = null,
    Object? address = null,
    Object? menuType = freezed,
    Object? drinkMenuType = freezed,
    Object? menu = freezed,
    Object? drinkMenu = freezed,
    Object? googlePageUrl = freezed,
    Object? restaurantImage = freezed,
    Object? reviewsCount = freezed,
    Object? checkedInCount = null,
    Object? bio = null,
    Object? newsletter = null,
    Object? ratings = null,
    Object? stateExists = freezed,
    Object? cityExists = freezed,
    Object? countryDetails = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? facebook = freezed,
    Object? instagram = freezed,
    Object? website = freezed,
    Object? stateDetails = freezed,
    Object? cityDetails = freezed,
    Object? reviews = null,
  }) {
    return _then(_value.copyWith(
      sId: null == sId
          ? _value.sId
          : sId // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as String,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as int?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfTables: null == numberOfTables
          ? _value.numberOfTables
          : numberOfTables // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      menuType: freezed == menuType
          ? _value.menuType
          : menuType // ignore: cast_nullable_to_non_nullable
              as String?,
      drinkMenuType: freezed == drinkMenuType
          ? _value.drinkMenuType
          : drinkMenuType // ignore: cast_nullable_to_non_nullable
              as String?,
      menu: freezed == menu
          ? _value.menu
          : menu // ignore: cast_nullable_to_non_nullable
              as String?,
      drinkMenu: freezed == drinkMenu
          ? _value.drinkMenu
          : drinkMenu // ignore: cast_nullable_to_non_nullable
              as String?,
      googlePageUrl: freezed == googlePageUrl
          ? _value.googlePageUrl
          : googlePageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      restaurantImage: freezed == restaurantImage
          ? _value.restaurantImage
          : restaurantImage // ignore: cast_nullable_to_non_nullable
              as RestaurantImage?,
      reviewsCount: freezed == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      checkedInCount: null == checkedInCount
          ? _value.checkedInCount
          : checkedInCount // ignore: cast_nullable_to_non_nullable
              as int,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      newsletter: null == newsletter
          ? _value.newsletter
          : newsletter // ignore: cast_nullable_to_non_nullable
              as bool,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as double,
      stateExists: freezed == stateExists
          ? _value.stateExists
          : stateExists // ignore: cast_nullable_to_non_nullable
              as int?,
      cityExists: freezed == cityExists
          ? _value.cityExists
          : cityExists // ignore: cast_nullable_to_non_nullable
              as int?,
      countryDetails: freezed == countryDetails
          ? _value.countryDetails
          : countryDetails // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as String?,
      instagram: freezed == instagram
          ? _value.instagram
          : instagram // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      stateDetails: freezed == stateDetails
          ? _value.stateDetails
          : stateDetails // ignore: cast_nullable_to_non_nullable
              as RestaurantListStateDetails?,
      cityDetails: freezed == cityDetails
          ? _value.cityDetails
          : cityDetails // ignore: cast_nullable_to_non_nullable
              as RestaurantListStateDetails?,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<GoogleReview>,
    ) as $Val);
  }

  /// Create a copy of RestaurantListResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RestaurantImageCopyWith<$Res>? get restaurantImage {
    if (_value.restaurantImage == null) {
      return null;
    }

    return $RestaurantImageCopyWith<$Res>(_value.restaurantImage!, (value) {
      return _then(_value.copyWith(restaurantImage: value) as $Val);
    });
  }

  /// Create a copy of RestaurantListResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RestaurantListStateDetailsCopyWith<$Res>? get stateDetails {
    if (_value.stateDetails == null) {
      return null;
    }

    return $RestaurantListStateDetailsCopyWith<$Res>(_value.stateDetails!,
        (value) {
      return _then(_value.copyWith(stateDetails: value) as $Val);
    });
  }

  /// Create a copy of RestaurantListResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RestaurantListStateDetailsCopyWith<$Res>? get cityDetails {
    if (_value.cityDetails == null) {
      return null;
    }

    return $RestaurantListStateDetailsCopyWith<$Res>(_value.cityDetails!,
        (value) {
      return _then(_value.copyWith(cityDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RestaurantListResultImplCopyWith<$Res>
    implements $RestaurantListResultCopyWith<$Res> {
  factory _$$RestaurantListResultImplCopyWith(_$RestaurantListResultImpl value,
          $Res Function(_$RestaurantListResultImpl) then) =
      __$$RestaurantListResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String sId,
      @JsonKey(name: 'email_verified') String emailVerified,
      @JsonKey(name: 'image') String logo,
      @JsonKey(name: 'lat') double lat,
      @JsonKey(name: 'lng') double lng,
      @JsonKey(name: 'active') String active,
      @JsonKey(name: 'deleted') String deleted,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'phoneNumber') String phoneNumber,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'updated') int? updated,
      @JsonKey(name: 'created') int? created,
      @JsonKey(name: 'number_of_tables') int numberOfTables,
      @JsonKey(name: 'address') String address,
      @JsonKey(name: 'menu_type') String? menuType,
      @JsonKey(name: 'drink_menu_type') String? drinkMenuType,
      @JsonKey(name: 'menu') String? menu,
      @JsonKey(name: 'drinkMenu') String? drinkMenu,
      @JsonKey(name: 'place_id') String? googlePageUrl,
      @JsonKey(name: 'restaurant_image') RestaurantImage? restaurantImage,
      @JsonKey(name: 'restaurantReviewCount') int? reviewsCount,
      int checkedInCount,
      String bio,
      bool newsletter,
      double ratings,
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
      List<GoogleReview> reviews});

  @override
  $RestaurantImageCopyWith<$Res>? get restaurantImage;
  @override
  $RestaurantListStateDetailsCopyWith<$Res>? get stateDetails;
  @override
  $RestaurantListStateDetailsCopyWith<$Res>? get cityDetails;
}

/// @nodoc
class __$$RestaurantListResultImplCopyWithImpl<$Res>
    extends _$RestaurantListResultCopyWithImpl<$Res, _$RestaurantListResultImpl>
    implements _$$RestaurantListResultImplCopyWith<$Res> {
  __$$RestaurantListResultImplCopyWithImpl(_$RestaurantListResultImpl _value,
      $Res Function(_$RestaurantListResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of RestaurantListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sId = null,
    Object? emailVerified = null,
    Object? logo = null,
    Object? lat = null,
    Object? lng = null,
    Object? active = null,
    Object? deleted = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? email = null,
    Object? updated = freezed,
    Object? created = freezed,
    Object? numberOfTables = null,
    Object? address = null,
    Object? menuType = freezed,
    Object? drinkMenuType = freezed,
    Object? menu = freezed,
    Object? drinkMenu = freezed,
    Object? googlePageUrl = freezed,
    Object? restaurantImage = freezed,
    Object? reviewsCount = freezed,
    Object? checkedInCount = null,
    Object? bio = null,
    Object? newsletter = null,
    Object? ratings = null,
    Object? stateExists = freezed,
    Object? cityExists = freezed,
    Object? countryDetails = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? facebook = freezed,
    Object? instagram = freezed,
    Object? website = freezed,
    Object? stateDetails = freezed,
    Object? cityDetails = freezed,
    Object? reviews = null,
  }) {
    return _then(_$RestaurantListResultImpl(
      sId: null == sId
          ? _value.sId
          : sId // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as String,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as int?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfTables: null == numberOfTables
          ? _value.numberOfTables
          : numberOfTables // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      menuType: freezed == menuType
          ? _value.menuType
          : menuType // ignore: cast_nullable_to_non_nullable
              as String?,
      drinkMenuType: freezed == drinkMenuType
          ? _value.drinkMenuType
          : drinkMenuType // ignore: cast_nullable_to_non_nullable
              as String?,
      menu: freezed == menu
          ? _value.menu
          : menu // ignore: cast_nullable_to_non_nullable
              as String?,
      drinkMenu: freezed == drinkMenu
          ? _value.drinkMenu
          : drinkMenu // ignore: cast_nullable_to_non_nullable
              as String?,
      googlePageUrl: freezed == googlePageUrl
          ? _value.googlePageUrl
          : googlePageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      restaurantImage: freezed == restaurantImage
          ? _value.restaurantImage
          : restaurantImage // ignore: cast_nullable_to_non_nullable
              as RestaurantImage?,
      reviewsCount: freezed == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      checkedInCount: null == checkedInCount
          ? _value.checkedInCount
          : checkedInCount // ignore: cast_nullable_to_non_nullable
              as int,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      newsletter: null == newsletter
          ? _value.newsletter
          : newsletter // ignore: cast_nullable_to_non_nullable
              as bool,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as double,
      stateExists: freezed == stateExists
          ? _value.stateExists
          : stateExists // ignore: cast_nullable_to_non_nullable
              as int?,
      cityExists: freezed == cityExists
          ? _value.cityExists
          : cityExists // ignore: cast_nullable_to_non_nullable
              as int?,
      countryDetails: freezed == countryDetails
          ? _value.countryDetails
          : countryDetails // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as String?,
      instagram: freezed == instagram
          ? _value.instagram
          : instagram // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      stateDetails: freezed == stateDetails
          ? _value.stateDetails
          : stateDetails // ignore: cast_nullable_to_non_nullable
              as RestaurantListStateDetails?,
      cityDetails: freezed == cityDetails
          ? _value.cityDetails
          : cityDetails // ignore: cast_nullable_to_non_nullable
              as RestaurantListStateDetails?,
      reviews: null == reviews
          ? _value._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<GoogleReview>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantListResultImpl implements _RestaurantListResult {
  const _$RestaurantListResultImpl(
      {@JsonKey(name: '_id') required this.sId,
      @JsonKey(name: 'email_verified') required this.emailVerified,
      @JsonKey(name: 'image') required this.logo,
      @JsonKey(name: 'lat') required this.lat,
      @JsonKey(name: 'lng') required this.lng,
      @JsonKey(name: 'active') required this.active,
      @JsonKey(name: 'deleted') required this.deleted,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'phoneNumber') required this.phoneNumber,
      @JsonKey(name: 'email') required this.email,
      @JsonKey(name: 'updated') this.updated,
      @JsonKey(name: 'created') this.created,
      @JsonKey(name: 'number_of_tables') required this.numberOfTables,
      @JsonKey(name: 'address') required this.address,
      @JsonKey(name: 'menu_type') this.menuType,
      @JsonKey(name: 'drink_menu_type') this.drinkMenuType,
      @JsonKey(name: 'menu') this.menu,
      @JsonKey(name: 'drinkMenu') this.drinkMenu,
      @JsonKey(name: 'place_id') this.googlePageUrl,
      @JsonKey(name: 'restaurant_image') this.restaurantImage,
      @JsonKey(name: 'restaurantReviewCount') this.reviewsCount,
      this.checkedInCount = 0,
      required this.bio,
      required this.newsletter,
      this.ratings = 0.0,
      this.stateExists,
      this.cityExists,
      this.countryDetails,
      this.city,
      this.state,
      this.country,
      this.facebook,
      this.instagram,
      this.website,
      this.stateDetails,
      this.cityDetails,
      final List<GoogleReview> reviews = const []})
      : _reviews = reviews;

  factory _$RestaurantListResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantListResultImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String sId;
  @override
  @JsonKey(name: 'email_verified')
  final String emailVerified;
  @override
  @JsonKey(name: 'image')
  final String logo;
  @override
  @JsonKey(name: 'lat')
  final double lat;
  @override
  @JsonKey(name: 'lng')
  final double lng;
  @override
  @JsonKey(name: 'active')
  final String active;
  @override
  @JsonKey(name: 'deleted')
  final String deleted;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;
  @override
  @JsonKey(name: 'email')
  final String email;
  @override
  @JsonKey(name: 'updated')
  final int? updated;
  @override
  @JsonKey(name: 'created')
  final int? created;
  @override
  @JsonKey(name: 'number_of_tables')
  final int numberOfTables;
  @override
  @JsonKey(name: 'address')
  final String address;
  @override
  @JsonKey(name: 'menu_type')
  final String? menuType;
  @override
  @JsonKey(name: 'drink_menu_type')
  final String? drinkMenuType;
  @override
  @JsonKey(name: 'menu')
  final String? menu;
  @override
  @JsonKey(name: 'drinkMenu')
  final String? drinkMenu;
  @override
  @JsonKey(name: 'place_id')
  final String? googlePageUrl;
  @override
  @JsonKey(name: 'restaurant_image')
  final RestaurantImage? restaurantImage;
  @override
  @JsonKey(name: 'restaurantReviewCount')
  final int? reviewsCount;
  @override
  @JsonKey()
  final int checkedInCount;
  @override
  final String bio;
  @override
  final bool newsletter;
  @override
  @JsonKey()
  final double ratings;
  @override
  final int? stateExists;
  @override
  final int? cityExists;
  @override
  final int? countryDetails;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? country;
  @override
  final String? facebook;
  @override
  final String? instagram;
  @override
  final String? website;
  @override
  final RestaurantListStateDetails? stateDetails;
  @override
  final RestaurantListStateDetails? cityDetails;
  final List<GoogleReview> _reviews;
  @override
  @JsonKey()
  List<GoogleReview> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  @override
  String toString() {
    return 'RestaurantListResult(sId: $sId, emailVerified: $emailVerified, logo: $logo, lat: $lat, lng: $lng, active: $active, deleted: $deleted, name: $name, phoneNumber: $phoneNumber, email: $email, updated: $updated, created: $created, numberOfTables: $numberOfTables, address: $address, menuType: $menuType, drinkMenuType: $drinkMenuType, menu: $menu, drinkMenu: $drinkMenu, googlePageUrl: $googlePageUrl, restaurantImage: $restaurantImage, reviewsCount: $reviewsCount, checkedInCount: $checkedInCount, bio: $bio, newsletter: $newsletter, ratings: $ratings, stateExists: $stateExists, cityExists: $cityExists, countryDetails: $countryDetails, city: $city, state: $state, country: $country, facebook: $facebook, instagram: $instagram, website: $website, stateDetails: $stateDetails, cityDetails: $cityDetails, reviews: $reviews)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantListResultImpl &&
            (identical(other.sId, sId) || other.sId == sId) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.numberOfTables, numberOfTables) ||
                other.numberOfTables == numberOfTables) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.menuType, menuType) ||
                other.menuType == menuType) &&
            (identical(other.drinkMenuType, drinkMenuType) ||
                other.drinkMenuType == drinkMenuType) &&
            (identical(other.menu, menu) || other.menu == menu) &&
            (identical(other.drinkMenu, drinkMenu) ||
                other.drinkMenu == drinkMenu) &&
            (identical(other.googlePageUrl, googlePageUrl) ||
                other.googlePageUrl == googlePageUrl) &&
            (identical(other.restaurantImage, restaurantImage) ||
                other.restaurantImage == restaurantImage) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.checkedInCount, checkedInCount) ||
                other.checkedInCount == checkedInCount) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.newsletter, newsletter) ||
                other.newsletter == newsletter) &&
            (identical(other.ratings, ratings) || other.ratings == ratings) &&
            (identical(other.stateExists, stateExists) ||
                other.stateExists == stateExists) &&
            (identical(other.cityExists, cityExists) ||
                other.cityExists == cityExists) &&
            (identical(other.countryDetails, countryDetails) ||
                other.countryDetails == countryDetails) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.facebook, facebook) ||
                other.facebook == facebook) &&
            (identical(other.instagram, instagram) ||
                other.instagram == instagram) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.stateDetails, stateDetails) ||
                other.stateDetails == stateDetails) &&
            (identical(other.cityDetails, cityDetails) ||
                other.cityDetails == cityDetails) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        sId,
        emailVerified,
        logo,
        lat,
        lng,
        active,
        deleted,
        name,
        phoneNumber,
        email,
        updated,
        created,
        numberOfTables,
        address,
        menuType,
        drinkMenuType,
        menu,
        drinkMenu,
        googlePageUrl,
        restaurantImage,
        reviewsCount,
        checkedInCount,
        bio,
        newsletter,
        ratings,
        stateExists,
        cityExists,
        countryDetails,
        city,
        state,
        country,
        facebook,
        instagram,
        website,
        stateDetails,
        cityDetails,
        const DeepCollectionEquality().hash(_reviews)
      ]);

  /// Create a copy of RestaurantListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantListResultImplCopyWith<_$RestaurantListResultImpl>
      get copyWith =>
          __$$RestaurantListResultImplCopyWithImpl<_$RestaurantListResultImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantListResultImplToJson(
      this,
    );
  }
}

abstract class _RestaurantListResult implements RestaurantListResult {
  const factory _RestaurantListResult(
      {@JsonKey(name: '_id') required final String sId,
      @JsonKey(name: 'email_verified') required final String emailVerified,
      @JsonKey(name: 'image') required final String logo,
      @JsonKey(name: 'lat') required final double lat,
      @JsonKey(name: 'lng') required final double lng,
      @JsonKey(name: 'active') required final String active,
      @JsonKey(name: 'deleted') required final String deleted,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'phoneNumber') required final String phoneNumber,
      @JsonKey(name: 'email') required final String email,
      @JsonKey(name: 'updated') final int? updated,
      @JsonKey(name: 'created') final int? created,
      @JsonKey(name: 'number_of_tables') required final int numberOfTables,
      @JsonKey(name: 'address') required final String address,
      @JsonKey(name: 'menu_type') final String? menuType,
      @JsonKey(name: 'drink_menu_type') final String? drinkMenuType,
      @JsonKey(name: 'menu') final String? menu,
      @JsonKey(name: 'drinkMenu') final String? drinkMenu,
      @JsonKey(name: 'place_id') final String? googlePageUrl,
      @JsonKey(name: 'restaurant_image') final RestaurantImage? restaurantImage,
      @JsonKey(name: 'restaurantReviewCount') final int? reviewsCount,
      final int checkedInCount,
      required final String bio,
      required final bool newsletter,
      final double ratings,
      final int? stateExists,
      final int? cityExists,
      final int? countryDetails,
      final String? city,
      final String? state,
      final String? country,
      final String? facebook,
      final String? instagram,
      final String? website,
      final RestaurantListStateDetails? stateDetails,
      final RestaurantListStateDetails? cityDetails,
      final List<GoogleReview> reviews}) = _$RestaurantListResultImpl;

  factory _RestaurantListResult.fromJson(Map<String, dynamic> json) =
      _$RestaurantListResultImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get sId;
  @override
  @JsonKey(name: 'email_verified')
  String get emailVerified;
  @override
  @JsonKey(name: 'image')
  String get logo;
  @override
  @JsonKey(name: 'lat')
  double get lat;
  @override
  @JsonKey(name: 'lng')
  double get lng;
  @override
  @JsonKey(name: 'active')
  String get active;
  @override
  @JsonKey(name: 'deleted')
  String get deleted;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'phoneNumber')
  String get phoneNumber;
  @override
  @JsonKey(name: 'email')
  String get email;
  @override
  @JsonKey(name: 'updated')
  int? get updated;
  @override
  @JsonKey(name: 'created')
  int? get created;
  @override
  @JsonKey(name: 'number_of_tables')
  int get numberOfTables;
  @override
  @JsonKey(name: 'address')
  String get address;
  @override
  @JsonKey(name: 'menu_type')
  String? get menuType;
  @override
  @JsonKey(name: 'drink_menu_type')
  String? get drinkMenuType;
  @override
  @JsonKey(name: 'menu')
  String? get menu;
  @override
  @JsonKey(name: 'drinkMenu')
  String? get drinkMenu;
  @override
  @JsonKey(name: 'place_id')
  String? get googlePageUrl;
  @override
  @JsonKey(name: 'restaurant_image')
  RestaurantImage? get restaurantImage;
  @override
  @JsonKey(name: 'restaurantReviewCount')
  int? get reviewsCount;
  @override
  int get checkedInCount;
  @override
  String get bio;
  @override
  bool get newsletter;
  @override
  double get ratings;
  @override
  int? get stateExists;
  @override
  int? get cityExists;
  @override
  int? get countryDetails;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get country;
  @override
  String? get facebook;
  @override
  String? get instagram;
  @override
  String? get website;
  @override
  RestaurantListStateDetails? get stateDetails;
  @override
  RestaurantListStateDetails? get cityDetails;
  @override
  List<GoogleReview> get reviews;

  /// Create a copy of RestaurantListResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantListResultImplCopyWith<_$RestaurantListResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

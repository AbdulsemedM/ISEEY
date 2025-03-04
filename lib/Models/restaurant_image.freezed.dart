// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RestaurantImage _$RestaurantImageFromJson(Map<String, dynamic> json) {
  return _RestaurantImage.fromJson(json);
}

/// @nodoc
mixin _$RestaurantImage {
  RestaurantImageSource get source => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this RestaurantImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantImageCopyWith<RestaurantImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantImageCopyWith<$Res> {
  factory $RestaurantImageCopyWith(
          RestaurantImage value, $Res Function(RestaurantImage) then) =
      _$RestaurantImageCopyWithImpl<$Res, RestaurantImage>;
  @useResult
  $Res call({RestaurantImageSource source, String? location});
}

/// @nodoc
class _$RestaurantImageCopyWithImpl<$Res, $Val extends RestaurantImage>
    implements $RestaurantImageCopyWith<$Res> {
  _$RestaurantImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? location = freezed,
  }) {
    return _then(_value.copyWith(
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as RestaurantImageSource,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RestaurantImageImplCopyWith<$Res>
    implements $RestaurantImageCopyWith<$Res> {
  factory _$$RestaurantImageImplCopyWith(_$RestaurantImageImpl value,
          $Res Function(_$RestaurantImageImpl) then) =
      __$$RestaurantImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RestaurantImageSource source, String? location});
}

/// @nodoc
class __$$RestaurantImageImplCopyWithImpl<$Res>
    extends _$RestaurantImageCopyWithImpl<$Res, _$RestaurantImageImpl>
    implements _$$RestaurantImageImplCopyWith<$Res> {
  __$$RestaurantImageImplCopyWithImpl(
      _$RestaurantImageImpl _value, $Res Function(_$RestaurantImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of RestaurantImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? location = freezed,
  }) {
    return _then(_$RestaurantImageImpl(
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as RestaurantImageSource,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantImageImpl implements _RestaurantImage {
  const _$RestaurantImageImpl({required this.source, required this.location});

  factory _$RestaurantImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantImageImplFromJson(json);

  @override
  final RestaurantImageSource source;
  @override
  final String? location;

  @override
  String toString() {
    return 'RestaurantImage(source: $source, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantImageImpl &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, source, location);

  /// Create a copy of RestaurantImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantImageImplCopyWith<_$RestaurantImageImpl> get copyWith =>
      __$$RestaurantImageImplCopyWithImpl<_$RestaurantImageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantImageImplToJson(
      this,
    );
  }
}

abstract class _RestaurantImage implements RestaurantImage {
  const factory _RestaurantImage(
      {required final RestaurantImageSource source,
      required final String? location}) = _$RestaurantImageImpl;

  factory _RestaurantImage.fromJson(Map<String, dynamic> json) =
      _$RestaurantImageImpl.fromJson;

  @override
  RestaurantImageSource get source;
  @override
  String? get location;

  /// Create a copy of RestaurantImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantImageImplCopyWith<_$RestaurantImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

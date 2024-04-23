// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_list_state_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RestaurantListStateDetails _$RestaurantListStateDetailsFromJson(
    Map<String, dynamic> json) {
  return _RestaurantListStateDetails.fromJson(json);
}

/// @nodoc
mixin _$RestaurantListStateDetails {
  String get sId => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RestaurantListStateDetailsCopyWith<RestaurantListStateDetails>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantListStateDetailsCopyWith<$Res> {
  factory $RestaurantListStateDetailsCopyWith(RestaurantListStateDetails value,
          $Res Function(RestaurantListStateDetails) then) =
      _$RestaurantListStateDetailsCopyWithImpl<$Res,
          RestaurantListStateDetails>;
  @useResult
  $Res call({String sId, int id, String name});
}

/// @nodoc
class _$RestaurantListStateDetailsCopyWithImpl<$Res,
        $Val extends RestaurantListStateDetails>
    implements $RestaurantListStateDetailsCopyWith<$Res> {
  _$RestaurantListStateDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sId = null,
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      sId: null == sId
          ? _value.sId
          : sId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RestaurantListStateDetailsImplCopyWith<$Res>
    implements $RestaurantListStateDetailsCopyWith<$Res> {
  factory _$$RestaurantListStateDetailsImplCopyWith(
          _$RestaurantListStateDetailsImpl value,
          $Res Function(_$RestaurantListStateDetailsImpl) then) =
      __$$RestaurantListStateDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sId, int id, String name});
}

/// @nodoc
class __$$RestaurantListStateDetailsImplCopyWithImpl<$Res>
    extends _$RestaurantListStateDetailsCopyWithImpl<$Res,
        _$RestaurantListStateDetailsImpl>
    implements _$$RestaurantListStateDetailsImplCopyWith<$Res> {
  __$$RestaurantListStateDetailsImplCopyWithImpl(
      _$RestaurantListStateDetailsImpl _value,
      $Res Function(_$RestaurantListStateDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sId = null,
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$RestaurantListStateDetailsImpl(
      sId: null == sId
          ? _value.sId
          : sId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantListStateDetailsImpl implements _RestaurantListStateDetails {
  const _$RestaurantListStateDetailsImpl(
      {required this.sId, required this.id, required this.name});

  factory _$RestaurantListStateDetailsImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RestaurantListStateDetailsImplFromJson(json);

  @override
  final String sId;
  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'RestaurantListStateDetails(sId: $sId, id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantListStateDetailsImpl &&
            (identical(other.sId, sId) || other.sId == sId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sId, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantListStateDetailsImplCopyWith<_$RestaurantListStateDetailsImpl>
      get copyWith => __$$RestaurantListStateDetailsImplCopyWithImpl<
          _$RestaurantListStateDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantListStateDetailsImplToJson(
      this,
    );
  }
}

abstract class _RestaurantListStateDetails
    implements RestaurantListStateDetails {
  const factory _RestaurantListStateDetails(
      {required final String sId,
      required final int id,
      required final String name}) = _$RestaurantListStateDetailsImpl;

  factory _RestaurantListStateDetails.fromJson(Map<String, dynamic> json) =
      _$RestaurantListStateDetailsImpl.fromJson;

  @override
  String get sId;
  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$RestaurantListStateDetailsImplCopyWith<_$RestaurantListStateDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

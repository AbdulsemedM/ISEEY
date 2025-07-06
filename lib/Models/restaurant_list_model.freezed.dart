// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RestaurantListModel _$RestaurantListModelFromJson(Map<String, dynamic> json) {
  return _RestaurantListModel.fromJson(json);
}

/// @nodoc
mixin _$RestaurantListModel {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<RestaurantListResult> get result => throw _privateConstructorUsedError;

  /// Serializes this RestaurantListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantListModelCopyWith<RestaurantListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantListModelCopyWith<$Res> {
  factory $RestaurantListModelCopyWith(
          RestaurantListModel value, $Res Function(RestaurantListModel) then) =
      _$RestaurantListModelCopyWithImpl<$Res, RestaurantListModel>;
  @useResult
  $Res call({bool success, String message, List<RestaurantListResult> result});
}

/// @nodoc
class _$RestaurantListModelCopyWithImpl<$Res, $Val extends RestaurantListModel>
    implements $RestaurantListModelCopyWith<$Res> {
  _$RestaurantListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? result = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as List<RestaurantListResult>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RestaurantListModelImplCopyWith<$Res>
    implements $RestaurantListModelCopyWith<$Res> {
  factory _$$RestaurantListModelImplCopyWith(_$RestaurantListModelImpl value,
          $Res Function(_$RestaurantListModelImpl) then) =
      __$$RestaurantListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, List<RestaurantListResult> result});
}

/// @nodoc
class __$$RestaurantListModelImplCopyWithImpl<$Res>
    extends _$RestaurantListModelCopyWithImpl<$Res, _$RestaurantListModelImpl>
    implements _$$RestaurantListModelImplCopyWith<$Res> {
  __$$RestaurantListModelImplCopyWithImpl(_$RestaurantListModelImpl _value,
      $Res Function(_$RestaurantListModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RestaurantListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? result = null,
  }) {
    return _then(_$RestaurantListModelImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value._result
          : result // ignore: cast_nullable_to_non_nullable
              as List<RestaurantListResult>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantListModelImpl implements _RestaurantListModel {
  const _$RestaurantListModelImpl(
      {required this.success,
      required this.message,
      required final List<RestaurantListResult> result})
      : _result = result;

  factory _$RestaurantListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantListModelImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  final List<RestaurantListResult> _result;
  @override
  List<RestaurantListResult> get result {
    if (_result is EqualUnmodifiableListView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_result);
  }

  @override
  String toString() {
    return 'RestaurantListModel(success: $success, message: $message, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantListModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._result, _result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message,
      const DeepCollectionEquality().hash(_result));

  /// Create a copy of RestaurantListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantListModelImplCopyWith<_$RestaurantListModelImpl> get copyWith =>
      __$$RestaurantListModelImplCopyWithImpl<_$RestaurantListModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantListModelImplToJson(
      this,
    );
  }
}

abstract class _RestaurantListModel implements RestaurantListModel {
  const factory _RestaurantListModel(
          {required final bool success,
          required final String message,
          required final List<RestaurantListResult> result}) =
      _$RestaurantListModelImpl;

  factory _RestaurantListModel.fromJson(Map<String, dynamic> json) =
      _$RestaurantListModelImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  List<RestaurantListResult> get result;

  /// Create a copy of RestaurantListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantListModelImplCopyWith<_$RestaurantListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

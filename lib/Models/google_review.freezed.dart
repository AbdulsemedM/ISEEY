// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GoogleReview _$GoogleReviewFromJson(Map<String, dynamic> json) {
  return _GoogleReview.fromJson(json);
}

/// @nodoc
mixin _$GoogleReview {
  @JsonKey(name: 'author_name')
  String get authorName => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoogleReviewCopyWith<GoogleReview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleReviewCopyWith<$Res> {
  factory $GoogleReviewCopyWith(
          GoogleReview value, $Res Function(GoogleReview) then) =
      _$GoogleReviewCopyWithImpl<$Res, GoogleReview>;
  @useResult
  $Res call(
      {@JsonKey(name: 'author_name') String authorName,
      int rating,
      String text});
}

/// @nodoc
class _$GoogleReviewCopyWithImpl<$Res, $Val extends GoogleReview>
    implements $GoogleReviewCopyWith<$Res> {
  _$GoogleReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorName = null,
    Object? rating = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoogleReviewImplCopyWith<$Res>
    implements $GoogleReviewCopyWith<$Res> {
  factory _$$GoogleReviewImplCopyWith(
          _$GoogleReviewImpl value, $Res Function(_$GoogleReviewImpl) then) =
      __$$GoogleReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'author_name') String authorName,
      int rating,
      String text});
}

/// @nodoc
class __$$GoogleReviewImplCopyWithImpl<$Res>
    extends _$GoogleReviewCopyWithImpl<$Res, _$GoogleReviewImpl>
    implements _$$GoogleReviewImplCopyWith<$Res> {
  __$$GoogleReviewImplCopyWithImpl(
      _$GoogleReviewImpl _value, $Res Function(_$GoogleReviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorName = null,
    Object? rating = null,
    Object? text = null,
  }) {
    return _then(_$GoogleReviewImpl(
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleReviewImpl implements _GoogleReview {
  const _$GoogleReviewImpl(
      {@JsonKey(name: 'author_name') required this.authorName,
      required this.rating,
      required this.text});

  factory _$GoogleReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleReviewImplFromJson(json);

  @override
  @JsonKey(name: 'author_name')
  final String authorName;
  @override
  final int rating;
  @override
  final String text;

  @override
  String toString() {
    return 'GoogleReview(authorName: $authorName, rating: $rating, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleReviewImpl &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, authorName, rating, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleReviewImplCopyWith<_$GoogleReviewImpl> get copyWith =>
      __$$GoogleReviewImplCopyWithImpl<_$GoogleReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleReviewImplToJson(
      this,
    );
  }
}

abstract class _GoogleReview implements GoogleReview {
  const factory _GoogleReview(
      {@JsonKey(name: 'author_name') required final String authorName,
      required final int rating,
      required final String text}) = _$GoogleReviewImpl;

  factory _GoogleReview.fromJson(Map<String, dynamic> json) =
      _$GoogleReviewImpl.fromJson;

  @override
  @JsonKey(name: 'author_name')
  String get authorName;
  @override
  int get rating;
  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$GoogleReviewImplCopyWith<_$GoogleReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

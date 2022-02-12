// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'split.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SplitResultTearOff {
  const _$SplitResultTearOff();

  _SplitResult call({required String sei, required String mei}) {
    return _SplitResult(
      sei: sei,
      mei: mei,
    );
  }
}

/// @nodoc
const $SplitResult = _$SplitResultTearOff();

/// @nodoc
mixin _$SplitResult {
  String get sei => throw _privateConstructorUsedError;
  String get mei => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SplitResultCopyWith<SplitResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplitResultCopyWith<$Res> {
  factory $SplitResultCopyWith(
          SplitResult value, $Res Function(SplitResult) then) =
      _$SplitResultCopyWithImpl<$Res>;
  $Res call({String sei, String mei});
}

/// @nodoc
class _$SplitResultCopyWithImpl<$Res> implements $SplitResultCopyWith<$Res> {
  _$SplitResultCopyWithImpl(this._value, this._then);

  final SplitResult _value;
  // ignore: unused_field
  final $Res Function(SplitResult) _then;

  @override
  $Res call({
    Object? sei = freezed,
    Object? mei = freezed,
  }) {
    return _then(_value.copyWith(
      sei: sei == freezed
          ? _value.sei
          : sei // ignore: cast_nullable_to_non_nullable
              as String,
      mei: mei == freezed
          ? _value.mei
          : mei // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$SplitResultCopyWith<$Res>
    implements $SplitResultCopyWith<$Res> {
  factory _$SplitResultCopyWith(
          _SplitResult value, $Res Function(_SplitResult) then) =
      __$SplitResultCopyWithImpl<$Res>;
  @override
  $Res call({String sei, String mei});
}

/// @nodoc
class __$SplitResultCopyWithImpl<$Res> extends _$SplitResultCopyWithImpl<$Res>
    implements _$SplitResultCopyWith<$Res> {
  __$SplitResultCopyWithImpl(
      _SplitResult _value, $Res Function(_SplitResult) _then)
      : super(_value, (v) => _then(v as _SplitResult));

  @override
  _SplitResult get _value => super._value as _SplitResult;

  @override
  $Res call({
    Object? sei = freezed,
    Object? mei = freezed,
  }) {
    return _then(_SplitResult(
      sei: sei == freezed
          ? _value.sei
          : sei // ignore: cast_nullable_to_non_nullable
              as String,
      mei: mei == freezed
          ? _value.mei
          : mei // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_SplitResult implements _SplitResult {
  _$_SplitResult({required this.sei, required this.mei});

  @override
  final String sei;
  @override
  final String mei;

  @override
  String toString() {
    return 'SplitResult(sei: $sei, mei: $mei)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SplitResult &&
            const DeepCollectionEquality().equals(other.sei, sei) &&
            const DeepCollectionEquality().equals(other.mei, mei));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(sei),
      const DeepCollectionEquality().hash(mei));

  @JsonKey(ignore: true)
  @override
  _$SplitResultCopyWith<_SplitResult> get copyWith =>
      __$SplitResultCopyWithImpl<_SplitResult>(this, _$identity);
}

abstract class _SplitResult implements SplitResult {
  factory _SplitResult({required String sei, required String mei}) =
      _$_SplitResult;

  @override
  String get sei;
  @override
  String get mei;
  @override
  @JsonKey(ignore: true)
  _$SplitResultCopyWith<_SplitResult> get copyWith =>
      throw _privateConstructorUsedError;
}

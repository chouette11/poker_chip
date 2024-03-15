// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blinds_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BlindsEntity _$BlindsEntityFromJson(Map<String, dynamic> json) {
  return _BlindsEntity.fromJson(json);
}

/// @nodoc
mixin _$BlindsEntity {
  int get sb => throw _privateConstructorUsedError;
  int get bb => throw _privateConstructorUsedError;
  int get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlindsEntityCopyWith<BlindsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlindsEntityCopyWith<$Res> {
  factory $BlindsEntityCopyWith(
          BlindsEntity value, $Res Function(BlindsEntity) then) =
      _$BlindsEntityCopyWithImpl<$Res, BlindsEntity>;
  @useResult
  $Res call({int sb, int bb, int time});
}

/// @nodoc
class _$BlindsEntityCopyWithImpl<$Res, $Val extends BlindsEntity>
    implements $BlindsEntityCopyWith<$Res> {
  _$BlindsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sb = null,
    Object? bb = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      sb: null == sb
          ? _value.sb
          : sb // ignore: cast_nullable_to_non_nullable
              as int,
      bb: null == bb
          ? _value.bb
          : bb // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlindsEntityImplCopyWith<$Res>
    implements $BlindsEntityCopyWith<$Res> {
  factory _$$BlindsEntityImplCopyWith(
          _$BlindsEntityImpl value, $Res Function(_$BlindsEntityImpl) then) =
      __$$BlindsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int sb, int bb, int time});
}

/// @nodoc
class __$$BlindsEntityImplCopyWithImpl<$Res>
    extends _$BlindsEntityCopyWithImpl<$Res, _$BlindsEntityImpl>
    implements _$$BlindsEntityImplCopyWith<$Res> {
  __$$BlindsEntityImplCopyWithImpl(
      _$BlindsEntityImpl _value, $Res Function(_$BlindsEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sb = null,
    Object? bb = null,
    Object? time = null,
  }) {
    return _then(_$BlindsEntityImpl(
      sb: null == sb
          ? _value.sb
          : sb // ignore: cast_nullable_to_non_nullable
              as int,
      bb: null == bb
          ? _value.bb
          : bb // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlindsEntityImpl extends _BlindsEntity {
  const _$BlindsEntityImpl(
      {required this.sb, required this.bb, required this.time})
      : super._();

  factory _$BlindsEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlindsEntityImplFromJson(json);

  @override
  final int sb;
  @override
  final int bb;
  @override
  final int time;

  @override
  String toString() {
    return 'BlindsEntity(sb: $sb, bb: $bb, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlindsEntityImpl &&
            (identical(other.sb, sb) || other.sb == sb) &&
            (identical(other.bb, bb) || other.bb == bb) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sb, bb, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlindsEntityImplCopyWith<_$BlindsEntityImpl> get copyWith =>
      __$$BlindsEntityImplCopyWithImpl<_$BlindsEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlindsEntityImplToJson(
      this,
    );
  }
}

abstract class _BlindsEntity extends BlindsEntity {
  const factory _BlindsEntity(
      {required final int sb,
      required final int bb,
      required final int time}) = _$BlindsEntityImpl;
  const _BlindsEntity._() : super._();

  factory _BlindsEntity.fromJson(Map<String, dynamic> json) =
      _$BlindsEntityImpl.fromJson;

  @override
  int get sb;
  @override
  int get bb;
  @override
  int get time;
  @override
  @JsonKey(ignore: true)
  _$$BlindsEntityImplCopyWith<_$BlindsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

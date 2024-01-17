// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'side_pot_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SidePotEntity {
  List<String> get uids => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SidePotEntityCopyWith<SidePotEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SidePotEntityCopyWith<$Res> {
  factory $SidePotEntityCopyWith(
          SidePotEntity value, $Res Function(SidePotEntity) then) =
      _$SidePotEntityCopyWithImpl<$Res, SidePotEntity>;
  @useResult
  $Res call({List<String> uids, int value});
}

/// @nodoc
class _$SidePotEntityCopyWithImpl<$Res, $Val extends SidePotEntity>
    implements $SidePotEntityCopyWith<$Res> {
  _$SidePotEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uids = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      uids: null == uids
          ? _value.uids
          : uids // ignore: cast_nullable_to_non_nullable
              as List<String>,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SidePotEntityCopyWith<$Res>
    implements $SidePotEntityCopyWith<$Res> {
  factory _$$_SidePotEntityCopyWith(
          _$_SidePotEntity value, $Res Function(_$_SidePotEntity) then) =
      __$$_SidePotEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> uids, int value});
}

/// @nodoc
class __$$_SidePotEntityCopyWithImpl<$Res>
    extends _$SidePotEntityCopyWithImpl<$Res, _$_SidePotEntity>
    implements _$$_SidePotEntityCopyWith<$Res> {
  __$$_SidePotEntityCopyWithImpl(
      _$_SidePotEntity _value, $Res Function(_$_SidePotEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uids = null,
    Object? value = null,
  }) {
    return _then(_$_SidePotEntity(
      uids: null == uids
          ? _value._uids
          : uids // ignore: cast_nullable_to_non_nullable
              as List<String>,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_SidePotEntity extends _SidePotEntity {
  const _$_SidePotEntity(
      {required final List<String> uids, required this.value})
      : _uids = uids,
        super._();

  final List<String> _uids;
  @override
  List<String> get uids {
    if (_uids is EqualUnmodifiableListView) return _uids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_uids);
  }

  @override
  final int value;

  @override
  String toString() {
    return 'SidePotEntity(uids: $uids, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SidePotEntity &&
            const DeepCollectionEquality().equals(other._uids, _uids) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_uids), value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SidePotEntityCopyWith<_$_SidePotEntity> get copyWith =>
      __$$_SidePotEntityCopyWithImpl<_$_SidePotEntity>(this, _$identity);
}

abstract class _SidePotEntity extends SidePotEntity {
  const factory _SidePotEntity(
      {required final List<String> uids,
      required final int value}) = _$_SidePotEntity;
  const _SidePotEntity._() : super._();

  @override
  List<String> get uids;
  @override
  int get value;
  @override
  @JsonKey(ignore: true)
  _$$_SidePotEntityCopyWith<_$_SidePotEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

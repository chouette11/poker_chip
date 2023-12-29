// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ActionEntity _$ActionEntityFromJson(Map<String, dynamic> json) {
  return _ActionEntity.fromJson(json);
}

/// @nodoc
mixin _$ActionEntity {
  String get uid => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionEntityCopyWith<ActionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionEntityCopyWith<$Res> {
  factory $ActionEntityCopyWith(
          ActionEntity value, $Res Function(ActionEntity) then) =
      _$ActionEntityCopyWithImpl<$Res, ActionEntity>;
  @useResult
  $Res call({String uid, String action, int? score});
}

/// @nodoc
class _$ActionEntityCopyWithImpl<$Res, $Val extends ActionEntity>
    implements $ActionEntityCopyWith<$Res> {
  _$ActionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? action = null,
    Object? score = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ActionEntityCopyWith<$Res>
    implements $ActionEntityCopyWith<$Res> {
  factory _$$_ActionEntityCopyWith(
          _$_ActionEntity value, $Res Function(_$_ActionEntity) then) =
      __$$_ActionEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, String action, int? score});
}

/// @nodoc
class __$$_ActionEntityCopyWithImpl<$Res>
    extends _$ActionEntityCopyWithImpl<$Res, _$_ActionEntity>
    implements _$$_ActionEntityCopyWith<$Res> {
  __$$_ActionEntityCopyWithImpl(
      _$_ActionEntity _value, $Res Function(_$_ActionEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? action = null,
    Object? score = freezed,
  }) {
    return _then(_$_ActionEntity(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ActionEntity extends _ActionEntity {
  const _$_ActionEntity({required this.uid, required this.action, this.score})
      : super._();

  factory _$_ActionEntity.fromJson(Map<String, dynamic> json) =>
      _$$_ActionEntityFromJson(json);

  @override
  final String uid;
  @override
  final String action;
  @override
  final int? score;

  @override
  String toString() {
    return 'ActionEntity(uid: $uid, action: $action, score: $score)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActionEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, action, score);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActionEntityCopyWith<_$_ActionEntity> get copyWith =>
      __$$_ActionEntityCopyWithImpl<_$_ActionEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActionEntityToJson(
      this,
    );
  }
}

abstract class _ActionEntity extends ActionEntity {
  const factory _ActionEntity(
      {required final String uid,
      required final String action,
      final int? score}) = _$_ActionEntity;
  const _ActionEntity._() : super._();

  factory _ActionEntity.fromJson(Map<String, dynamic> json) =
      _$_ActionEntity.fromJson;

  @override
  String get uid;
  @override
  String get action;
  @override
  int? get score;
  @override
  @JsonKey(ignore: true)
  _$$_ActionEntityCopyWith<_$_ActionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

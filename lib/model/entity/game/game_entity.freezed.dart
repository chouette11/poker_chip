// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GameEntity _$GameEntityFromJson(Map<String, dynamic> json) {
  return _GameEntity.fromJson(json);
}

/// @nodoc
mixin _$GameEntity {
  String get uid => throw _privateConstructorUsedError;
  GameTypeEnum get type => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameEntityCopyWith<GameEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameEntityCopyWith<$Res> {
  factory $GameEntityCopyWith(
          GameEntity value, $Res Function(GameEntity) then) =
      _$GameEntityCopyWithImpl<$Res, GameEntity>;
  @useResult
  $Res call({String uid, GameTypeEnum type, int? score});
}

/// @nodoc
class _$GameEntityCopyWithImpl<$Res, $Val extends GameEntity>
    implements $GameEntityCopyWith<$Res> {
  _$GameEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? type = null,
    Object? score = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GameTypeEnum,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GameEntityCopyWith<$Res>
    implements $GameEntityCopyWith<$Res> {
  factory _$$_GameEntityCopyWith(
          _$_GameEntity value, $Res Function(_$_GameEntity) then) =
      __$$_GameEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, GameTypeEnum type, int? score});
}

/// @nodoc
class __$$_GameEntityCopyWithImpl<$Res>
    extends _$GameEntityCopyWithImpl<$Res, _$_GameEntity>
    implements _$$_GameEntityCopyWith<$Res> {
  __$$_GameEntityCopyWithImpl(
      _$_GameEntity _value, $Res Function(_$_GameEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? type = null,
    Object? score = freezed,
  }) {
    return _then(_$_GameEntity(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GameTypeEnum,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GameEntity extends _GameEntity {
  const _$_GameEntity({required this.uid, required this.type, this.score})
      : super._();

  factory _$_GameEntity.fromJson(Map<String, dynamic> json) =>
      _$$_GameEntityFromJson(json);

  @override
  final String uid;
  @override
  final GameTypeEnum type;
  @override
  final int? score;

  @override
  String toString() {
    return 'GameEntity(uid: $uid, type: $type, score: $score)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GameEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, type, score);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GameEntityCopyWith<_$_GameEntity> get copyWith =>
      __$$_GameEntityCopyWithImpl<_$_GameEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GameEntityToJson(
      this,
    );
  }
}

abstract class _GameEntity extends GameEntity {
  const factory _GameEntity(
      {required final String uid,
      required final GameTypeEnum type,
      final int? score}) = _$_GameEntity;
  const _GameEntity._() : super._();

  factory _GameEntity.fromJson(Map<String, dynamic> json) =
      _$_GameEntity.fromJson;

  @override
  String get uid;
  @override
  GameTypeEnum get type;
  @override
  int? get score;
  @override
  @JsonKey(ignore: true)
  _$$_GameEntityCopyWith<_$_GameEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

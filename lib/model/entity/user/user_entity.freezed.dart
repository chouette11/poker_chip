// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return _UserEntity.fromJson(json);
}

/// @nodoc
mixin _$UserEntity {
  String get uid => throw _privateConstructorUsedError;
  int get assignedId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int get stack => throw _privateConstructorUsedError;
  bool get isBtn => throw _privateConstructorUsedError;
  bool get isFold => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserEntityCopyWith<UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
          UserEntity value, $Res Function(UserEntity) then) =
      _$UserEntityCopyWithImpl<$Res, UserEntity>;
  @useResult
  $Res call(
      {String uid,
      int assignedId,
      String? name,
      int stack,
      bool isBtn,
      bool isFold,
      int? score});
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res, $Val extends UserEntity>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? assignedId = null,
    Object? name = freezed,
    Object? stack = null,
    Object? isBtn = null,
    Object? isFold = null,
    Object? score = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      assignedId: null == assignedId
          ? _value.assignedId
          : assignedId // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      stack: null == stack
          ? _value.stack
          : stack // ignore: cast_nullable_to_non_nullable
              as int,
      isBtn: null == isBtn
          ? _value.isBtn
          : isBtn // ignore: cast_nullable_to_non_nullable
              as bool,
      isFold: null == isFold
          ? _value.isFold
          : isFold // ignore: cast_nullable_to_non_nullable
              as bool,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserEntityCopyWith<$Res>
    implements $UserEntityCopyWith<$Res> {
  factory _$$_UserEntityCopyWith(
          _$_UserEntity value, $Res Function(_$_UserEntity) then) =
      __$$_UserEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      int assignedId,
      String? name,
      int stack,
      bool isBtn,
      bool isFold,
      int? score});
}

/// @nodoc
class __$$_UserEntityCopyWithImpl<$Res>
    extends _$UserEntityCopyWithImpl<$Res, _$_UserEntity>
    implements _$$_UserEntityCopyWith<$Res> {
  __$$_UserEntityCopyWithImpl(
      _$_UserEntity _value, $Res Function(_$_UserEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? assignedId = null,
    Object? name = freezed,
    Object? stack = null,
    Object? isBtn = null,
    Object? isFold = null,
    Object? score = freezed,
  }) {
    return _then(_$_UserEntity(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      assignedId: null == assignedId
          ? _value.assignedId
          : assignedId // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      stack: null == stack
          ? _value.stack
          : stack // ignore: cast_nullable_to_non_nullable
              as int,
      isBtn: null == isBtn
          ? _value.isBtn
          : isBtn // ignore: cast_nullable_to_non_nullable
              as bool,
      isFold: null == isFold
          ? _value.isFold
          : isFold // ignore: cast_nullable_to_non_nullable
              as bool,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserEntity extends _UserEntity {
  const _$_UserEntity(
      {required this.uid,
      required this.assignedId,
      this.name,
      required this.stack,
      required this.isBtn,
      required this.isFold,
      this.score})
      : super._();

  factory _$_UserEntity.fromJson(Map<String, dynamic> json) =>
      _$$_UserEntityFromJson(json);

  @override
  final String uid;
  @override
  final int assignedId;
  @override
  final String? name;
  @override
  final int stack;
  @override
  final bool isBtn;
  @override
  final bool isFold;
  @override
  final int? score;

  @override
  String toString() {
    return 'UserEntity(uid: $uid, assignedId: $assignedId, name: $name, stack: $stack, isBtn: $isBtn, isFold: $isFold, score: $score)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.assignedId, assignedId) ||
                other.assignedId == assignedId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.stack, stack) || other.stack == stack) &&
            (identical(other.isBtn, isBtn) || other.isBtn == isBtn) &&
            (identical(other.isFold, isFold) || other.isFold == isFold) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uid, assignedId, name, stack, isBtn, isFold, score);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserEntityCopyWith<_$_UserEntity> get copyWith =>
      __$$_UserEntityCopyWithImpl<_$_UserEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserEntityToJson(
      this,
    );
  }
}

abstract class _UserEntity extends UserEntity {
  const factory _UserEntity(
      {required final String uid,
      required final int assignedId,
      final String? name,
      required final int stack,
      required final bool isBtn,
      required final bool isFold,
      final int? score}) = _$_UserEntity;
  const _UserEntity._() : super._();

  factory _UserEntity.fromJson(Map<String, dynamic> json) =
      _$_UserEntity.fromJson;

  @override
  String get uid;
  @override
  int get assignedId;
  @override
  String? get name;
  @override
  int get stack;
  @override
  bool get isBtn;
  @override
  bool get isFold;
  @override
  int? get score;
  @override
  @JsonKey(ignore: true)
  _$$_UserEntityCopyWith<_$_UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

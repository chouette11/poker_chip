// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'peer_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PeerEntity {
  String get uid => throw _privateConstructorUsedError;
  Peer get peer => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PeerEntityCopyWith<PeerEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeerEntityCopyWith<$Res> {
  factory $PeerEntityCopyWith(
          PeerEntity value, $Res Function(PeerEntity) then) =
      _$PeerEntityCopyWithImpl<$Res, PeerEntity>;
  @useResult
  $Res call({String uid, Peer peer});
}

/// @nodoc
class _$PeerEntityCopyWithImpl<$Res, $Val extends PeerEntity>
    implements $PeerEntityCopyWith<$Res> {
  _$PeerEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? peer = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      peer: null == peer
          ? _value.peer
          : peer // ignore: cast_nullable_to_non_nullable
              as Peer,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PeerEntityCopyWith<$Res>
    implements $PeerEntityCopyWith<$Res> {
  factory _$$_PeerEntityCopyWith(
          _$_PeerEntity value, $Res Function(_$_PeerEntity) then) =
      __$$_PeerEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, Peer peer});
}

/// @nodoc
class __$$_PeerEntityCopyWithImpl<$Res>
    extends _$PeerEntityCopyWithImpl<$Res, _$_PeerEntity>
    implements _$$_PeerEntityCopyWith<$Res> {
  __$$_PeerEntityCopyWithImpl(
      _$_PeerEntity _value, $Res Function(_$_PeerEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? peer = null,
  }) {
    return _then(_$_PeerEntity(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      peer: null == peer
          ? _value.peer
          : peer // ignore: cast_nullable_to_non_nullable
              as Peer,
    ));
  }
}

/// @nodoc

class _$_PeerEntity extends _PeerEntity {
  const _$_PeerEntity({required this.uid, required this.peer}) : super._();

  @override
  final String uid;
  @override
  final Peer peer;

  @override
  String toString() {
    return 'PeerEntity(uid: $uid, peer: $peer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PeerEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.peer, peer) || other.peer == peer));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, peer);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PeerEntityCopyWith<_$_PeerEntity> get copyWith =>
      __$$_PeerEntityCopyWithImpl<_$_PeerEntity>(this, _$identity);
}

abstract class _PeerEntity extends PeerEntity {
  const factory _PeerEntity(
      {required final String uid, required final Peer peer}) = _$_PeerEntity;
  const _PeerEntity._() : super._();

  @override
  String get uid;
  @override
  Peer get peer;
  @override
  @JsonKey(ignore: true)
  _$$_PeerEntityCopyWith<_$_PeerEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

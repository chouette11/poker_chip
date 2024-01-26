// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'peer_con_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PeerConEntity {
  String get uid => throw _privateConstructorUsedError;
  String get peerId => throw _privateConstructorUsedError;
  DataConnection get con => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PeerConEntityCopyWith<PeerConEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeerConEntityCopyWith<$Res> {
  factory $PeerConEntityCopyWith(
          PeerConEntity value, $Res Function(PeerConEntity) then) =
      _$PeerConEntityCopyWithImpl<$Res, PeerConEntity>;
  @useResult
  $Res call({String uid, String peerId, DataConnection con});
}

/// @nodoc
class _$PeerConEntityCopyWithImpl<$Res, $Val extends PeerConEntity>
    implements $PeerConEntityCopyWith<$Res> {
  _$PeerConEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? peerId = null,
    Object? con = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      peerId: null == peerId
          ? _value.peerId
          : peerId // ignore: cast_nullable_to_non_nullable
              as String,
      con: null == con
          ? _value.con
          : con // ignore: cast_nullable_to_non_nullable
              as DataConnection,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PeerConEntityImplCopyWith<$Res>
    implements $PeerConEntityCopyWith<$Res> {
  factory _$$PeerConEntityImplCopyWith(
          _$PeerConEntityImpl value, $Res Function(_$PeerConEntityImpl) then) =
      __$$PeerConEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, String peerId, DataConnection con});
}

/// @nodoc
class __$$PeerConEntityImplCopyWithImpl<$Res>
    extends _$PeerConEntityCopyWithImpl<$Res, _$PeerConEntityImpl>
    implements _$$PeerConEntityImplCopyWith<$Res> {
  __$$PeerConEntityImplCopyWithImpl(
      _$PeerConEntityImpl _value, $Res Function(_$PeerConEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? peerId = null,
    Object? con = null,
  }) {
    return _then(_$PeerConEntityImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      peerId: null == peerId
          ? _value.peerId
          : peerId // ignore: cast_nullable_to_non_nullable
              as String,
      con: null == con
          ? _value.con
          : con // ignore: cast_nullable_to_non_nullable
              as DataConnection,
    ));
  }
}

/// @nodoc

class _$PeerConEntityImpl extends _PeerConEntity {
  const _$PeerConEntityImpl(
      {required this.uid, required this.peerId, required this.con})
      : super._();

  @override
  final String uid;
  @override
  final String peerId;
  @override
  final DataConnection con;

  @override
  String toString() {
    return 'PeerConEntity(uid: $uid, peerId: $peerId, con: $con)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeerConEntityImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.peerId, peerId) || other.peerId == peerId) &&
            (identical(other.con, con) || other.con == con));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, peerId, con);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PeerConEntityImplCopyWith<_$PeerConEntityImpl> get copyWith =>
      __$$PeerConEntityImplCopyWithImpl<_$PeerConEntityImpl>(this, _$identity);
}

abstract class _PeerConEntity extends PeerConEntity {
  const factory _PeerConEntity(
      {required final String uid,
      required final String peerId,
      required final DataConnection con}) = _$PeerConEntityImpl;
  const _PeerConEntity._() : super._();

  @override
  String get uid;
  @override
  String get peerId;
  @override
  DataConnection get con;
  @override
  @JsonKey(ignore: true)
  _$$PeerConEntityImplCopyWith<_$PeerConEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

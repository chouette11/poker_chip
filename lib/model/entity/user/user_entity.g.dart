// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserEntity _$$_UserEntityFromJson(Map<String, dynamic> json) =>
    _$_UserEntity(
      uid: json['uid'] as String,
      assignedId: json['assignedId'] as int,
      name: json['name'] as String?,
      stack: json['stack'] as int,
      isBtn: json['isBtn'] as bool,
      isFold: json['isFold'] as bool,
      score: json['score'] as int?,
    );

Map<String, dynamic> _$$_UserEntityToJson(_$_UserEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'assignedId': instance.assignedId,
      'name': instance.name,
      'stack': instance.stack,
      'isBtn': instance.isBtn,
      'isFold': instance.isFold,
      'score': instance.score,
    };

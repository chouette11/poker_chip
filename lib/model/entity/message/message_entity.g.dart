// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessageEntity _$$_MessageEntityFromJson(Map<String, dynamic> json) =>
    _$_MessageEntity(
      type: $enumDecode(_$MessageTypeEnumEnumMap, json['type']),
      content: json['content'],
    );

Map<String, dynamic> _$$_MessageEntityToJson(_$_MessageEntity instance) =>
    <String, dynamic>{
      'type': _$MessageTypeEnumEnumMap[instance.type]!,
      'content': instance.content,
    };

const _$MessageTypeEnumEnumMap = {
  MessageTypeEnum.join: 'join',
  MessageTypeEnum.joined: 'joined',
  MessageTypeEnum.action: 'action',
};

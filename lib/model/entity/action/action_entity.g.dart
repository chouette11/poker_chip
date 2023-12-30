// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ActionEntity _$$_ActionEntityFromJson(Map<String, dynamic> json) =>
    _$_ActionEntity(
      uid: json['uid'] as String,
      type: $enumDecode(_$ActionTypeEnumEnumMap, json['type']),
      score: json['score'] as int?,
    );

Map<String, dynamic> _$$_ActionEntityToJson(_$_ActionEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'type': _$ActionTypeEnumEnumMap[instance.type]!,
      'score': instance.score,
    };

const _$ActionTypeEnumEnumMap = {
  ActionTypeEnum.call: 'call',
  ActionTypeEnum.raise: 'raise',
  ActionTypeEnum.fold: 'fold',
  ActionTypeEnum.check: 'check',
  ActionTypeEnum.bet: 'bet',
  ActionTypeEnum.pot: 'pot',
  ActionTypeEnum.anty: 'anty',
  ActionTypeEnum.blind: 'blind',
};

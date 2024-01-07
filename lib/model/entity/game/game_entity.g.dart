// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GameEntity _$$_GameEntityFromJson(Map<String, dynamic> json) =>
    _$_GameEntity(
      uid: json['uid'] as String,
      type: $enumDecode(_$GameTypeEnumEnumMap, json['type']),
      score: json['score'] as int,
    );

Map<String, dynamic> _$$_GameEntityToJson(_$_GameEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'type': _$GameTypeEnumEnumMap[instance.type]!,
      'score': instance.score,
    };

const _$GameTypeEnumEnumMap = {
  GameTypeEnum.pot: 'pot',
  GameTypeEnum.anty: 'anty',
  GameTypeEnum.btn: 'btn',
  GameTypeEnum.blind: 'blind',
  GameTypeEnum.preFlop: 'preFlop',
  GameTypeEnum.flop: 'flop',
  GameTypeEnum.turn: 'turn',
  GameTypeEnum.river: 'river',
  GameTypeEnum.foldout: 'foldout',
  GameTypeEnum.wtsd: 'wtsd',
};

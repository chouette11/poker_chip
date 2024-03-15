import 'package:freezed_annotation/freezed_annotation.dart';

part 'blinds_entity.freezed.dart';

part 'blinds_entity.g.dart';

@freezed
class BlindsEntity with _$BlindsEntity {
  const BlindsEntity._();

  const factory BlindsEntity({
    required int sb,
    required int bb,
    required int time,
  }) = _BlindsEntity;

  factory BlindsEntity.fromJson(Map<String, dynamic> json) =>
      _$BlindsEntityFromJson(json);
}

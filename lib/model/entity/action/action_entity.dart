import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:poker_chip/model/document/action/action_document.dart';

part 'action_entity.freezed.dart';

part 'action_entity.g.dart';

@freezed
class ActionEntity with _$ActionEntity {
  const ActionEntity._();

  const factory ActionEntity({
    required int id,
    required String action,
    int? score,
  }) = _ActionEntity;

  factory ActionEntity.fromJson(Map<String, dynamic> json) =>
      _$ActionEntityFromJson(json);

  static ActionEntity fromDoc(ActionDocument actionDoc) {
    return ActionEntity(
      id: actionDoc.id, 
      action: actionDoc.action,
      score: actionDoc.score,
    );
  }

  ActionDocument toActionDocument() {
    return ActionDocument(
      id: id,
      action: action,
      score: score,
    );
  }
}

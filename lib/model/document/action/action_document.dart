import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:poker_chip/model/document/timestamp_converter.dart';

part 'action_document.freezed.dart';

part 'action_document.g.dart';

@freezed
class ActionDocument with _$ActionDocument {
  const ActionDocument._();

  const factory ActionDocument({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'action') required String action,
    @JsonKey(name: 'score') int? score,

  }) = _ActionDocument;

  factory ActionDocument.fromJson(Map<String, dynamic> json) =>
      _$ActionDocumentFromJson(json);
}

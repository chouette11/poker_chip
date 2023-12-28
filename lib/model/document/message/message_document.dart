import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:poker_chip/model/document/message/timestamp_converter.dart';

part 'message_document.freezed.dart';

part 'message_document.g.dart';

@freezed
class MessageDocument with _$MessageDocument {
  const MessageDocument._();

  const factory MessageDocument({
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'content') required dynamic content,
  }) = _MessageDocument;

  factory MessageDocument.fromJson(Map<String, dynamic> json) =>
      _$MessageDocumentFromJson(json);
}

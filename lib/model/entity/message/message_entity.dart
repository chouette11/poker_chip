import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:poker_chip/model/document/message/message_document.dart';

part 'message_entity.freezed.dart';
part 'message_entity.g.dart';


@freezed
class MessageEntity with _$MessageEntity {
    const MessageEntity._();

  const factory MessageEntity({
    required String type,
    required dynamic content,
    bool? isQuestion,
  }) = _MessageEntity;

   factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);

  static MessageEntity fromDoc(MessageDocument taskDoc) {
    return MessageEntity(
      type: taskDoc.type,
      content: taskDoc.content,
    );
  }

  MessageDocument toMessageDocument() {
    return MessageDocument(
      type: type,
      content: content,
    );
  }
}

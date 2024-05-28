import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_document.freezed.dart';

part 'room_document.g.dart';

@freezed
class RoomDocument with _$RoomDocument {
  const RoomDocument._();

  const factory RoomDocument({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'stack') required int stack,
    @JsonKey(name: 'sb') required int sb,
    @JsonKey(name: 'bb') required int bb,

  }) = _RoomDocument;

  factory RoomDocument.fromJson(Map<String, dynamic> json) =>
      _$RoomDocumentFromJson(json);
}
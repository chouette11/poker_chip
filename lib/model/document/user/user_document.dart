import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_document.freezed.dart';

part 'user_document.g.dart';

@freezed
class UserDocument with _$UserDocument {
  const UserDocument._();

  const factory UserDocument({
    @JsonKey(name: 'uid') required String uid,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'stack') required int stack,
  }) = _UserDocument;

  factory UserDocument.fromJson(Map<String, dynamic> json) =>
      _$UserDocumentFromJson(json);
}

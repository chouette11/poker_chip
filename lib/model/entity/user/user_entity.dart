import 'package:poker_chip/model/document/user/user_document.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const UserEntity._();

  const factory UserEntity({
    required String uid,
    String? name,
    required int stack,
  }) = _UserEntity;

  static UserEntity fromDoc(UserDocument userDoc) {
    return UserEntity(
      uid: userDoc.uid,
      name: userDoc.name,
      stack: userDoc.stack,
    );
  }

  UserDocument toUserDocument() {
    return UserDocument(
      uid: uid,
      name: name,
      stack: stack,
    );
  }
}

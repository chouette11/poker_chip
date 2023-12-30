import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_entity.freezed.dart';

@freezed
class MemberEntity with _$MemberEntity {
  const MemberEntity._();

  const factory MemberEntity({
    required String uid,
    required int assignedId,
    required String role,
    required bool isLive,
    required int voted,
  }) = _MemberEntity;

}

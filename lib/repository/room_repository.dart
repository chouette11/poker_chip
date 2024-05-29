import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/data/firestore_data_source.dart';
import 'package:poker_chip/model/entity/room/room_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/presentation_providers.dart';

final roomRepositoryProvider =
    Provider<RoomRepository>((ref) => RoomRepository(ref));

class RoomRepository {
  RoomRepository(this.ref);

  final Ref ref;

  Future<void> createRoom(int id) async {
    final firestore = ref.read(firestoreProvider);
    final room = RoomEntity(
      id: id,
      stack: ref.read(stackProvider),
      sb: ref.read(sbProvider),
      bb: ref.read(bbProvider),
    );
    await firestore.createRoom(room.toRoomDocument());
  }

  Future<void> joinRoom(int id, UserEntity userEntity) async {
    final firestore = ref.read(firestoreProvider);
    await firestore.insertMember(userEntity, id);
  }

  Future<RoomEntity> getRoom(int id) async {
    final firestore = ref.read(firestoreProvider);
    final room = await firestore.fetchRoom(id);
    return RoomEntity.fromDoc(room);
  }

  Future<List<UserEntity>> getMembers(int roomId) {
    final firestore = ref.read(firestoreProvider);
    return firestore.fetchMembers(roomId);
  }

  Future<void> initMember(int roomId, UserEntity userEntity) async {
    print('changeUser');
    print(userEntity);
    final firestore = ref.read(firestoreProvider);
    firestore.updateMember(
        roomId: roomId,
        uid: userEntity.uid,
        assignedId: userEntity.assignedId,
        name: userEntity.name,
        stack: userEntity.stack,
        isBtn: userEntity.isBtn,
        isAction: userEntity.isAction,
        isCheck: userEntity.isCheck,
        isFold: userEntity.isFold,
        isSitOut: userEntity.isSitOut,
        score: userEntity.score);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMemberStream(int roomId) {
    final firestore = ref.read(firestoreProvider);
    return firestore.fetchMemberStream(roomId);
  }
}

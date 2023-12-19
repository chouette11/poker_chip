import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/data/firestore_data_source.dart';
import 'package:poker_chip/model/entity/room/room_entity.dart';

final roomRepositoryProvider =
    Provider<RoomRepository>((ref) => RoomRepository(ref));

class RoomRepository {
  RoomRepository(this.ref);

  final Ref ref;

  /// ルームのストリーム取得
  Stream<RoomEntity> getRoomStream(String roomId) {
    final firestore = ref.read(firestoreProvider);
    return firestore.fetchRoomStream(roomId).map(
          (event) => RoomEntity.fromDoc(event),
        );
  }

  Future<RoomEntity> getRoom(String roomId) async {
    final firestore = ref.read(firestoreProvider);
    final roomDoc = await firestore.fetchRoom(roomId);
    return RoomEntity.fromDoc(roomDoc);
  }

  /// キルメンバーのリセット
  Future<void> resetKilledId(String roomId) async {
    final firestore = ref.read(firestoreProvider);
    await firestore.updateRoom(id: roomId, killedId: 404);
  }
}

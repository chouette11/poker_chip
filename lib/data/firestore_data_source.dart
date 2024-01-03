import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/domain_providers.dart';

final firestoreProvider =
    Provider<FirestoreDataSource>((ref) => FirestoreDataSource(ref: ref));

class FirestoreDataSource {
  FirestoreDataSource({required this.ref});

  final Ref ref;

  ///
  /// Message
  ///

  /// メッセージをすべて削除
  Future<void> deleteAllMessage(String roomId) async {
    final db = ref.read(firebaseFirestoreProvider);
    final collection = db.collection('rooms/$roomId/messages');
    await collection.get().asStream().forEach((element) {
      for (var element in element.docs) {
        element.reference.delete();
      }
    });
  }

  /// Room

  /// ルームを削除
  Future<void> deleteRoom(String roomId) async {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      await db.collection('rooms').doc(roomId).delete();
    } catch (e) {
      print('delete_room');
      throw e;
    }
  }
}

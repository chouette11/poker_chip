import 'package:poker_chip/model/document/user/user_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/document/message/message_document.dart';
import 'package:poker_chip/model/document/action/action_document.dart';
import 'package:poker_chip/provider/domain_providers.dart';
import 'package:poker_chip/provider/presentation_providers.dart';

final firestoreProvider =
    Provider<FirestoreDataSource>((ref) => FirestoreDataSource(ref: ref));

class FirestoreDataSource {
  FirestoreDataSource({required this.ref});

  final Ref ref;

  ///
  /// Message
  ///

  Stream<List<MessageDocument>> fetchMessageStream(String roomId) {
    try {
      final db = ref.read(firebaseFirestoreProvider);

      final stream = db
          .collection('rooms/$roomId/messages')
          .orderBy('createdAt', descending: true)
          .snapshots();
      return stream.map((event) => event.docs
          .map((doc) => doc.data())
          .map((data) => MessageDocument.fromJson(data))
          .toList());
    } catch (e) {
      print('firestore_getMessageStream');
      throw e;
    }
  }

  /// 新規メッセージ追加
  Future<String> insertMessage(
      MessageDocument messageDocument, String roomId) async {
    final db = ref.read(firebaseFirestoreProvider);
    final collection = db.collection('rooms/$roomId/messages');
    final docRef =
        await collection.add(messageDocument.copyWith.call().toJson());
    return docRef.id;
  }

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

  /// User
  Future<void> insertUser(UserDocument userEntity) async {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      final uid = ref.read(uidProvider);
      final collection = db.collection('users');
      await collection.doc(uid).set(userEntity.toJson());
    } catch (e) {
      print('firestore_getMemberStream');
      throw e;
    }
  }
}

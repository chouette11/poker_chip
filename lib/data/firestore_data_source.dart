import 'package:flutter_template/model/document/user/user_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/model/document/message/message_document.dart';
import 'package:flutter_template/model/document/room/room_document.dart';
import 'package:flutter_template/provider/domain_providers.dart';
import 'package:flutter_template/provider/presentation_providers.dart';

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
    final docRef = await collection.add(messageDocument.copyWith.call().toJson());
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

  /// ルームの更新
  Future<void> updateMessage({
    required String docId,
    required String roomId,
    String? content,
    String? uid,
    DateTime? createdAt,
    bool? isQuestion,
  }) async {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      final docRef = db.collection('rooms/$roomId/messages').doc(docId);
      await db.runTransaction((Transaction transaction) async {
        // トランザクション内でドキュメントを読み込む
        final snapshot = await transaction.get(docRef);
        final room = MessageDocument.fromJson(snapshot.data()!);

        // ドキュメントを更新する
        transaction.update(
            docRef,
            room.copyWith
                .call(
                  content: content ?? room.content,
                  uid: uid ?? room.uid,
                  createdAt: createdAt ?? room.createdAt,
                  isQuestion: isQuestion ?? room.isQuestion,
            )
                .toJson());
      });
    } catch (e) {
      print('update_message');
      throw e;
    }
  }

  /// Room

  /// 新規ルーム追加
  Future<void> createLocalRoom(RoomDocument roomDocument) async {
    final db = ref.read(firebaseFirestoreProvider);
    final collection = db.collection('rooms');
    await collection
        .doc(roomDocument.id)
        .set(roomDocument.copyWith.call().toJson());
  }

  /// 新規オンラインルーム追加
  Future<void> createRoom(RoomDocument roomDocument) async {
    final db = ref.read(firebaseFirestoreProvider);
    final collection = db.collection('rooms');
    await collection
        .doc(roomDocument.id)
        .set(roomDocument.copyWith(createdAt: DateTime.now()).toJson());
  }

  /// ルームを取得
  Future<RoomDocument> fetchRoom(String roomId) async {
    final db = ref.read(firebaseFirestoreProvider);
    final room = await db.collection('rooms').doc(roomId).get();
    return RoomDocument.fromJson(room.data()!);
  }

  /// 最新のオンラインルームを取得
  Future<RoomDocument?> fetchLatestRoom() async {
    final db = ref.read(firebaseFirestoreProvider);
    final room = await db
        .collection('rooms')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    if (room.size == 0) {
      return null;
    }
    return RoomDocument.fromJson(room.docs.first.data());
  }

  /// ルームののストリームを取得
  Stream<RoomDocument> fetchRoomStream(String roomId) {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      final stream = db.collection('rooms').doc(roomId).snapshots();
      return stream.map((event) => RoomDocument.fromJson(event.data()!));
    } catch (e) {
      print('firestore_getMemberStream');
      throw e;
    }
  }

  /// ルームの一覧を取得
  Future<List<RoomDocument>> fetchRooms() async {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      final rooms = await db.collection('rooms').get();
      return rooms.docs.map((e) => RoomDocument.fromJson(e.data())).toList();
    } catch (e) {
      print('firestore_getStream');
      throw e;
    }
  }

  /// ルームの更新
  Future<void> updateRoom({
    required String id,
    String? topic,
    int? maxNum,
    List<String>? roles,
    int? votedSum,
    int? killedId,
    DateTime? startTime,
  }) async {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      final docRef = db.collection('rooms').doc(id);
      await db.runTransaction((Transaction transaction) async {
        // トランザクション内でドキュメントを読み込む
        final snapshot = await transaction.get(docRef);
        final room = RoomDocument.fromJson(snapshot.data()!);

        // ドキュメントを更新する
        transaction.update(
            docRef,
            room.copyWith
                .call(
                  topic: topic ?? room.topic,
                  maxNum: maxNum ?? room.maxNum,
                  roles: roles ?? room.roles,
                  votedSum: votedSum ?? room.votedSum,
                  killedId: killedId ?? room.killedId,
                  startTime: startTime ?? room.startTime,
                )
                .toJson());
      });
    } catch (e) {
      print('update_room');
      throw e;
    }
  }

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

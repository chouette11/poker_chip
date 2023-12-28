import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/data/api_data_source.dart';
import 'package:poker_chip/data/firestore_data_source.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/provider/presentation_providers.dart';

final messageRepositoryProvider =
    Provider<MessageRepository>((ref) => MessageRepository(ref));

class MessageRepository {
  MessageRepository(this.ref);

  final Ref ref;

  /// タスクのストリームを取得
  Stream<List<MessageEntity>> getMessageStream(String roomId) {
    final firestore = ref.read(firestoreProvider);
    return firestore.fetchMessageStream(roomId).map(
          (event) => event.map((e) => MessageEntity.fromDoc(e)).toList(),
        );
  }

  /// すべてのメッセージを削除
  Future<void> deleteAllMessage(String roomId) async {
    final firestore = ref.read(firestoreProvider);
    await firestore.deleteAllMessage(roomId);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/provider/presentation/peer.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/message.dart';

class SitButton extends ConsumerWidget {
  const SitButton({super.key, required this.isHost});

  final bool isHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        if (isHost) {
          final players = ref.read(playerDataProvider);
          final uid = ref.read(uidProvider);
          final myData = players.firstWhere((e) => e.uid == uid);

          /// Hostの状態変更
          ref.read(playerDataProvider.notifier).updateSitOut(uid, false);

          /// Participantの状態変更
          final mes = MessageEntity(type: MessageTypeEnum.userSetting,
              content: myData.copyWith.call(isSitOut: false));
          ref.read(hostConsProvider.notifier).send(mes);
        } else {
          final conn = ref.read(participantConProvider);
          final uid = ref.read(uidProvider);
          final players = ref.read(playerDataProvider);
          final myData = players.firstWhere((e) => e.uid == uid);

          final mes = MessageEntity(
              type: MessageTypeEnum.userSetting,
              content: myData.copyWith.call(isSitOut: false));
          conn!.send(mes);
        }
      },
      child: Text('参加'),
    );
  }
}

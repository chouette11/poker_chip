import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';

class HostWhoWinButton extends ConsumerWidget {
  const HostWhoWinButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(roundProvider);
    final sidePots = ref.watch(hostSidePotsProvider);
    return Visibility(
      visible: round == GameTypeEnum.showdown && sidePots.isEmpty,
      child: ElevatedButton(
        onPressed: () {
          final players = ref.read(playerDataProvider);
          final List<String> uids = [];
          final cons = ref.read(hostConsProvider);

          for (final player in players) {
            if (ref.read(isSelectedProvider(player))) {
              uids.add(player.uid);
            }
          }

          final score = ref.read(potProvider) ~/ uids.length;

          for (final uid in uids) {
            /// HostのStack状態変更
            ref.read(playerDataProvider.notifier).updateStack(uid, score);

            /// Participantのstack状態変更
            for (final conEntity in cons) {
              final conn = conEntity.con;
              final game =
              GameEntity(uid: uid, type: GameTypeEnum.showdown, score: score);
              final mes = MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            }
          }

          /// HostのOption状態変更
          ref.read(roundProvider.notifier).delayPreFlop();

          /// ParticipantのOption状態変更
          for (final conEntity in cons) {
            final conn = conEntity.con;
            const game =
            GameEntity(uid: '', type: GameTypeEnum.preFlop, score: 0);
            const mes = MessageEntity(type: MessageTypeEnum.game, content: game);
            conn.send(mes.toJson());
          }
        },
        child: const Text('確定'),
      ),
    );
  }
}
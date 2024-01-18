import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/side_pot/side_pot_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';

class HostRankingButton extends ConsumerWidget {
  const HostRankingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(roundProvider);
    final sidePots = ref.watch(hostSidePotsProvider);
    return Visibility(
      visible: round == GameTypeEnum.showdown && sidePots.isNotEmpty,
      child: ElevatedButton(
        onPressed: () {
          final List<UserEntity> players =
              List.from(ref.read(playerDataProvider));
          players.removeWhere((e) => e.isFold == true);
          final cons = ref.read(hostConsProvider);
          final List<String> uids = [];

          for (final player in players) {
            if (ref.read(isSelectedProvider(player))) {
              uids.add(player.uid);
            }
          }
          ref.read(rankingProvider.notifier).addUserUids(uids);

          final selectedLen =
              ref.read(rankingProvider.notifier).selectedLength();
          bool isAllSelected = players.length == selectedLen;

          if (isAllSelected) {
            final ranking = ref.read(rankingProvider);
            final sidePots = ref.read(hostSidePotsProvider);
            final distributionMap = _distributeSidePots(sidePots, ranking);
            final uids = distributionMap.keys.toList();

            for (final uid in uids) {
              final score = distributionMap[uid] ?? 0;

              /// HostのStack状態変更
              ref.read(playerDataProvider.notifier).updateStack(uid, score);

              /// Participantのstack状態変更
              for (final conEntity in cons) {
                final conn = conEntity.con;
                final game = GameEntity(
                    uid: uid, type: GameTypeEnum.showdown, score: score);
                final mes =
                    MessageEntity(type: MessageTypeEnum.game, content: game);
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
              const mes =
                  MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            }
          }
        },
        child: const Text('確定'),
      ),
    );
  }
}

/// { uid: score }
Map<String, int> _distributeSidePots(
    List<SidePotEntity> sidePots, List<List<String>> rankings) {
  // 各ユーザーに分配されるチップの量を記録するマップ
  Map<String, int> distributions = {};

  // 各サイドポットに対して
  for (var pot in sidePots) {
    // このポットを獲得できる最高ランクを見つける
    List<String> eligibleWinners = [];
    for (var rank in rankings) {
      eligibleWinners = rank.where((uid) => pot.uids.contains(uid)).toList();
      if (eligibleWinners.isNotEmpty) {
        break;
      }
    }

    // サイドポットを関連する勝者に分配
    int potShare = pot.size ~/ eligibleWinners.length;
    for (var winner in eligibleWinners) {
      distributions.update(winner, (value) => value + potShare,
          ifAbsent: () => potShare);
    }
  }

  return distributions;
}

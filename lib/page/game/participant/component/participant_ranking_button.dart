import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';

class ParticipantRankingButton extends ConsumerWidget {
  const ParticipantRankingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(roundProvider);
    final sidePot = ref.watch(sidePotsProvider);
    return Visibility(
      visible: round == GameTypeEnum.showdown && sidePot.isNotEmpty,
      child: ElevatedButton(
        onPressed: () {
          Map<String, int> rankingMap = {};
          final players = ref.read(playerDataProvider);
          for (final player in players) {
            final rank = ref.read(rankingProvider(player));
            rankingMap[player.uid] = rank;
          }

          final conn = ref.read(participantConProvider);
          if (conn == null) {
            return;
          }

          final json = jsonEncode(rankingMap);
          print(json);
          final game =
              GameEntity(uid: json, type: GameTypeEnum.ranking, score: 0);
          final mes = MessageEntity(type: MessageTypeEnum.game, content: game);
          print(mes);
          conn.send(mes.toJson());
        },
        child: const Text('確定'),
      ),
    );
  }
}

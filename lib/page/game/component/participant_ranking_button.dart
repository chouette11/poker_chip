import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/side_pot/side_pot_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';

class ParticipantRankingButton extends ConsumerWidget {
  const ParticipantRankingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(roundProvider);
    return Visibility(
      visible: round == GameTypeEnum.showdown,
      child: ElevatedButton(
        onPressed: () {

        },
        child: const Text('確定'),
      ),
    );
  }
}

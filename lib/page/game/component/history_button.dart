import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/presentation/history.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/context_extension.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';
import 'package:poker_chip/util/enum/game.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(context: context, builder: (context) => _CustomDialog());
      },
      child: Text('履歴'),
    );
  }
}

class _CustomDialog extends ConsumerWidget {
  const _CustomDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    List<UserEntity> players = [];
    print('history');
    print(history);
    return Dialog(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '履歴',
              style: TextStyleConstant.bold16
                  .copyWith(color: ColorConstant.black10),
            ),
          ),
          SizedBox(
            height: history.length * 64 + 16,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                reverse: true,
                children: history
                    .map(
                      (e) => _CustomTile(
                        dateTime: e.dateTime,
                        action: e.action,
                        round: e.round,
                        onTap: () {
                          players = e.players;
                          print(players);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(playerDataProvider.notifier).restore(players);
            },
            child: Text('復元'),
          )
        ],
      ),
    );
  }
}

class _CustomTile extends ConsumerWidget {
  const _CustomTile({
    super.key,
    this.action,
    this.game,
    required this.onTap,
    required this.dateTime,
    required this.round,
  });

  final DateTime dateTime;
  final GameTypeEnum round;
  final ActionEntity? action;
  final GameEntity? game;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (action != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: ColorConstant.black80.withOpacity(0.4),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(_datetimeToString(dateTime)),
                    Text(round.name),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_uidToName(action!.uid, ref, context)}   ',
                      style: TextStyleConstant.bold16
                          .copyWith(color: ColorConstant.black10),
                    ),
                    Text(
                      action!.type.displayName,
                      style: TextStyleConstant.bold16
                          .copyWith(color: ColorConstant.black10),
                    ),
                    Visibility(
                      visible: action!.score != 0,
                      child: Text(
                        ':${action!.score.toString()}',
                        style: TextStyleConstant.bold16
                            .copyWith(color: ColorConstant.black10),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Text(dateTime.hour.toString()),
          Text(_uidToName(game!.uid, ref, context))
        ],
      );
    }
  }
}

String _uidToName(String uid, WidgetRef ref, BuildContext context) {
  final players = ref.read(playerDataProvider);
  return players.firstWhere((e) => e.uid == uid).name ??
      context.l10n.playerX(1);
}

String _datetimeToString(DateTime dateTime) {
  return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}  ';
}

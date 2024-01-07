import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/page/game/host_page.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';

class HostActionButtons extends ConsumerWidget {
  const HostActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget children() {
      final players = ref.watch(playerDataProvider);
      final maxScore = _findMaxInList(players.map((e) => e.score).toList());
      final me = players.firstWhere((e) => e.uid == ref.watch(uidProvider));
      if (maxScore == 0 || me.score == maxScore) {
        return Column(
          children: [
            _ActionButton(
                actionTypeEnum: ActionTypeEnum.bet, maxScore: maxScore),
            _ActionButton(
                actionTypeEnum: ActionTypeEnum.check, maxScore: maxScore),
            _ActionButton(
                actionTypeEnum: ActionTypeEnum.fold, maxScore: maxScore)
          ],
        );
      } else {
        return Column(
          children: [
            _ActionButton(
                actionTypeEnum: ActionTypeEnum.raise, maxScore: maxScore),
            _ActionButton(
                actionTypeEnum: ActionTypeEnum.call, maxScore: maxScore),
            _ActionButton(
                actionTypeEnum: ActionTypeEnum.fold, maxScore: maxScore)
          ],
        );
      }
    }

    bool isVisible(int optAssignedId) {
      final uid = assignedIdToUid(optAssignedId, ref);
      return ref.read(uidProvider) == uid;
    }

    final optAssignedId = ref.watch(optionAssignedIdProvider);
    return Visibility(visible: isVisible(optAssignedId), child: children());
  }
}

class _ActionButton extends ConsumerWidget {
  const _ActionButton({
    super.key,
    required this.actionTypeEnum,
    required this.maxScore,
  });

  final ActionTypeEnum actionTypeEnum;
  final int maxScore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cons = ref.watch(hostConsProvider);
    final uid = ref.watch(uidProvider);
    final betScore = ref.watch(raiseBetProvider);

    return ElevatedButton(
      onPressed: () {
        final notifier = ref.read(playerDataProvider.notifier);

        /// HostのStack状態変更
        _hostActionMethod(ref, actionTypeEnum, uid, maxScore);

        /// HostのOption状態変更
        if (notifier.isAllAction() && notifier.isSameScore()) {
          ref.read(optionAssignedIdProvider.notifier).updatePostFlopId();
          ref.read(orderProvider.notifier).nextOrder();
          ref.read(potProvider.notifier).changeOrder();
          ref.read(playerDataProvider.notifier).clearScore();
          ref.read(playerDataProvider.notifier).clearIsAction();
        } else {
          ref.read(optionAssignedIdProvider.notifier).updateId();
        }

        /// ParticipantのStack状態変更
        final optId = ref.read(optionAssignedIdProvider);
        int score = 0;
        if (actionTypeEnum == ActionTypeEnum.raise ||
            actionTypeEnum == ActionTypeEnum.bet) {
          score = betScore;
        } else if (actionTypeEnum == ActionTypeEnum.call) {
          score = maxScore;
        }
        for (final conEntity in cons) {
          final conn = conEntity.con;
          final action = ActionEntity(
            uid: uid,
            type: actionTypeEnum,
            score: score,
            optId: optId,
          );
          final mes =
              MessageEntity(type: MessageTypeEnum.action, content: action);
          conn.send(mes.toJson());
        }

        if (notifier.isAllAction() && notifier.isSameScore()) {
          /// Participantのターン状態変更
          for (final conEntity in cons) {
            final conn = conEntity.con;
            final order = ref.read(orderProvider);
            final game = GameEntity(uid: '', type: order, score: 0);
            final mes =
                MessageEntity(type: MessageTypeEnum.game, content: game);
            conn.send(mes.toJson());
          }
        }
      },
      child: Text(actionTypeEnum.name),
    );
  }
}

int _findMaxInList(List<int> numbers) {
  // リストが空の場合は例外を投げる
  if (numbers.isEmpty) {
    throw ArgumentError("List is empty");
  }

  int maxValue = numbers[0];
  for (int number in numbers) {
    if (number > maxValue) {
      maxValue = number;
    }
  }
  return maxValue;
}

void _hostActionMethod(
    WidgetRef ref, ActionTypeEnum type, String uid, int maxScore) {
  ref.read(playerDataProvider.notifier).updateAction(uid);
  final score = ref.read(raiseBetProvider);
  switch (type) {
    case ActionTypeEnum.fold:
      ref.read(playerDataProvider.notifier).updateFold(uid);
      break;
    case ActionTypeEnum.call:
      ref.read(playerDataProvider.notifier).updateStack(uid, maxScore);
      ref.read(playerDataProvider.notifier).updateScore(uid, maxScore);
      break;
    case ActionTypeEnum.raise:
      ref.read(playerDataProvider.notifier).updateStack(uid, score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      break;
    case ActionTypeEnum.bet:
      ref.read(playerDataProvider.notifier).updateStack(uid, score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      break;
    case ActionTypeEnum.check:
      break;
  }
}

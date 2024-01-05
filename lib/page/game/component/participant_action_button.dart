import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/page/game/host_page.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/message.dart';

class ParticipantActionButtons extends ConsumerWidget {
  const ParticipantActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget children() {
      final players = ref.watch(playerDataProvider);
      final maxScore = findMaxInList(players.map((e) => e.score).toList());
      if (maxScore == 0) {
        return Column(
          children: [
            _ActionButton(actionTypeEnum: ActionTypeEnum.bet, maxScore: maxScore),
            _ActionButton(
                actionTypeEnum: ActionTypeEnum.check, maxScore: maxScore),
            _ActionButton(actionTypeEnum: ActionTypeEnum.fold, maxScore: maxScore)
          ],
        );
      } else {
        return Column(
          children: [
            _ActionButton(
                actionTypeEnum: ActionTypeEnum.raise, maxScore: maxScore),
            _ActionButton(
                actionTypeEnum: ActionTypeEnum.call, maxScore: maxScore),
            _ActionButton(actionTypeEnum: ActionTypeEnum.fold, maxScore: maxScore)
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
    final conn = ref.watch(participantConProvider);
    final uid = ref.watch(uidProvider);
    final score = ref.watch(raiseBetProvider);
    return ElevatedButton(
      onPressed: () {
        if (conn == null) {
          return;
        }
        switch (actionTypeEnum) {
          case ActionTypeEnum.fold:
            final action = ActionEntity(uid: uid, type: actionTypeEnum, score: 0);
            final mes =
                MessageEntity(type: MessageTypeEnum.action, content: action);
            conn.send(mes.toJson());
            break;
          case ActionTypeEnum.call:
            final action =
                ActionEntity(uid: uid, type: actionTypeEnum, score: maxScore);
            final mes =
                MessageEntity(type: MessageTypeEnum.action, content: action);
            conn.send(mes.toJson());
            break;
          case ActionTypeEnum.raise:
            final action =
                ActionEntity(uid: uid, type: actionTypeEnum, score: score);
            final mes =
                MessageEntity(type: MessageTypeEnum.action, content: action);
            conn.send(mes.toJson());
            break;
          case ActionTypeEnum.check:
            break;
          case ActionTypeEnum.bet:
            final action =
                ActionEntity(uid: uid, type: actionTypeEnum, score: score);
            final mes =
                MessageEntity(type: MessageTypeEnum.action, content: action);
            conn.send(mes.toJson());
            break;
        }
      },
      child: Text(actionTypeEnum.name),
    );
  }
}

int findMaxInList(List<int> numbers) {
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/page/game/paticipant_page.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/message.dart';

class HostActionButtons extends ConsumerWidget {
  const HostActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playerDataProvider);
    final maxScore = findMaxInList(players.map((e) => e.score ?? 0).toList());
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
    final score = ref.watch(raiseBetProvider);
    return ElevatedButton(
      onPressed: () {
        /// Hostの状態変更
        _hostActionMethod(ref, actionTypeEnum, uid, maxScore);

        /// Participantへの送信
        switch (actionTypeEnum) {
          case ActionTypeEnum.fold:
            ref.read(playerDataProvider.notifier).updateFold(uid);
            for (final conEntity in cons) {
              final conn = conEntity.con;
              final action = ActionEntity(uid: uid, type: actionTypeEnum);
              final mes =
                  MessageEntity(type: MessageTypeEnum.action, content: action);
              conn.send(mes.toJson());
            }
            break;
          case ActionTypeEnum.call:
            ref.read(playerDataProvider.notifier).updateScore(uid, maxScore);
            for (final conEntity in cons) {
              final conn = conEntity.con;
              final action =
                  ActionEntity(uid: uid, type: actionTypeEnum, score: maxScore);
              final mes =
                  MessageEntity(type: MessageTypeEnum.action, content: action);
              conn.send(mes.toJson());
            }
            break;
          case ActionTypeEnum.raise:
            ref.read(playerDataProvider.notifier).updateScore(uid, score);
            for (final conEntity in cons) {
              final conn = conEntity.con;
              final action =
                  ActionEntity(uid: uid, type: actionTypeEnum, score: score);
              final mes =
                  MessageEntity(type: MessageTypeEnum.action, content: action);
              conn.send(mes.toJson());
            }
            break;
          case ActionTypeEnum.check:
            break;
          case ActionTypeEnum.bet:
            ref.read(playerDataProvider.notifier).updateScore(uid, score);
            for (final conEntity in cons) {
              final conn = conEntity.con;
              final action =
                  ActionEntity(uid: uid, type: actionTypeEnum, score: score);
              final mes =
                  MessageEntity(type: MessageTypeEnum.action, content: action);
              conn.send(mes.toJson());
            }
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

void _hostActionMethod(WidgetRef ref, ActionTypeEnum type, String uid, int maxScore) {
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
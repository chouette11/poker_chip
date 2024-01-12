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
    final round = ref.watch(roundProvider);

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
      if (round == GameTypeEnum.foldout || round == GameTypeEnum.showdown) {
        return false;
      }
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
    final myUid = ref.watch(uidProvider);
    final betScore = ref.watch(raiseBetProvider);

    return ElevatedButton(
      onPressed: () {
        final notifier = ref.read(playerDataProvider.notifier);

        /// HostのStack状態変更
        _hostActionMethod(ref, actionTypeEnum, myUid, maxScore);

        /// HostのOption状態変更
        final isFoldout = notifier.isFoldout();
        final isChangeRound = notifier.isAllAction() && notifier.isSameScore();
        if (isFoldout) {
          final uid = notifier.finalPlayerUid().first;
          final myUid = ref.read(uidProvider);
          ref.read(roundProvider.notifier).update(GameTypeEnum.foldout);
          ref.read(potProvider.notifier).scoreSumToPot();
          ref.read(playerDataProvider.notifier).clearScore();
          final pot = ref.read(potProvider);
          ref.read(playerDataProvider.notifier).updateStack(uid, pot);
          ref.read(playerDataProvider.notifier).clearIsFold();
          ref.read(potProvider.notifier).clear();
          ref.read(smallIdProvider.notifier).updateId();
          ref.read(bigIdProvider.notifier).updateId();
          ref.read(btnIdProvider.notifier).updateId();
          ref.read(optionAssignedIdProvider.notifier).updatePreFlopId();
          ref.read(roundProvider.notifier).delayPreFlop();
          if (uid == myUid) {
            ref.read(isWinProvider.notifier).update((state) => true);
          }
        } else if (isChangeRound) {
          ref.read(potProvider.notifier).scoreSumToPot();
          ref.read(playerDataProvider.notifier).clearScore();
          ref.read(optionAssignedIdProvider.notifier).updatePostFlopId();
          ref.read(roundProvider.notifier).nextRound();
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
            uid: myUid,
            type: actionTypeEnum,
            score: score,
            optId: optId,
          );
          final mes =
              MessageEntity(type: MessageTypeEnum.action, content: action);
          conn.send(mes.toJson());
        }

        if (isFoldout) {
          /// Participantのターン状態変更
          for (final conEntity in cons) {
            final conn = conEntity.con;
            final ids = notifier.finalPlayerUid();
            final round = ref.read(roundProvider);
            final game = GameEntity(uid: ids.first, type: round, score: 0);
            final mes =
            MessageEntity(type: MessageTypeEnum.game, content: game);
            conn.send(mes.toJson());

            Future.delayed(const Duration(seconds: 4), () {
              print('timer!');
              final round = ref.read(roundProvider);
              final game = GameEntity(uid: '', type: round, score: 0);
              final mes =
              MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            });
          }
        } else if (isChangeRound) {
          /// Participantのターン状態変更
          for (final conEntity in cons) {
            final conn = conEntity.con;
            final round = ref.read(roundProvider);
            final game = GameEntity(uid: '', type: round, score: 0);
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

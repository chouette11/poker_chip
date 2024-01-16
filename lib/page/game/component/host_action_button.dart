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
    final myScore = ref.watch(playerDataProvider.notifier).curScore(myUid);
    final myStack = ref.watch(playerDataProvider.notifier).curStack(myUid);
    final score = _fixScoreSize(actionTypeEnum, betScore, maxScore, myStack);

    return ElevatedButton(
      onPressed: () {
        final notifier = ref.read(playerDataProvider.notifier);

        /// HostのStack状態変更
        _hostActionMethod(ref, actionTypeEnum, myUid, score);

        /// HostのOption状態変更
        final isFoldout = notifier.isFoldout();
        final isChangeRound = notifier.isAllAction() && notifier.isSameScore();
        if (isFoldout) {
          final uid = notifier.finalPlayerUid().first;
          ref.read(roundProvider.notifier).update(GameTypeEnum.foldout);
          ref.read(playerDataProvider.notifier).clearScore();
          final pot = ref.read(potProvider);
          ref.read(playerDataProvider.notifier).updateStack(uid, pot);
          ref.read(smallIdProvider.notifier).updateId();
          ref.read(bigIdProvider.notifier).updateId();
          ref.read(btnIdProvider.notifier).updateId();
          ref.read(optionAssignedIdProvider.notifier).updatePreFlopId();
          ref.read(roundProvider.notifier).delayPreFlop();
        } else if (isChangeRound) {
          ref.read(playerDataProvider.notifier).clearScore();
          ref.read(optionAssignedIdProvider.notifier).updatePostFlopId();
          ref.read(roundProvider.notifier).nextRound();
          ref.read(playerDataProvider.notifier).clearIsAction();
          final round = ref.read(roundProvider);
          if (round == GameTypeEnum.showdown) {
            ref.read(smallIdProvider.notifier).updateId();
            ref.read(bigIdProvider.notifier).updateId();
            ref.read(btnIdProvider.notifier).updateId();
            ref.read(optionAssignedIdProvider.notifier).updatePreFlopId();
          }
        } else {
          ref.read(optionAssignedIdProvider.notifier).updateId();
        }

        /// ParticipantのStack状態変更
        final optId = ref.read(optionAssignedIdProvider);
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

        /// bet額リセット
        ref.read(raiseBetProvider.notifier).update((state) => 0);
      },
      child: Column(
        children: [
          Text(actionTypeEnum.name),
          Visibility(
            visible: actionTypeEnum == ActionTypeEnum.bet ||
                actionTypeEnum == ActionTypeEnum.raise,
            child: Text(score.toString()),
          ),
          Visibility(
            visible: actionTypeEnum == ActionTypeEnum.call,
            child: Text((score - myScore).toString()),
          )
        ],
      ),
    );
  }
}

int _fixScoreSize(
    ActionTypeEnum actionTypeEnum, int betScore, int maxScore, int stack) {
  int score = 0;
  if (actionTypeEnum == ActionTypeEnum.raise ||
      actionTypeEnum == ActionTypeEnum.bet) {
    score = betScore;
  } else if (actionTypeEnum == ActionTypeEnum.call) {
    score = maxScore;
  }
  if (score > stack) {
    score = stack;
  }
  return score;
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
    WidgetRef ref, ActionTypeEnum type, String uid, int score) {
  ref.read(playerDataProvider.notifier).updateAction(uid);
  switch (type) {
    case ActionTypeEnum.fold:
      ref.read(playerDataProvider.notifier).updateFold(uid);
      break;
    case ActionTypeEnum.call:
      final curScore = ref.read(playerDataProvider.notifier).curScore(uid);
      final fixScore = score - curScore;
      ref.read(playerDataProvider.notifier).updateStack(uid, -fixScore);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      ref.read(potProvider.notifier).potUpdate(fixScore);
      break;
    case ActionTypeEnum.raise:
      ref.read(playerDataProvider.notifier).updateStack(uid, -score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      ref.read(potProvider.notifier).potUpdate(score);
      break;
    case ActionTypeEnum.bet:
      ref.read(playerDataProvider.notifier).updateStack(uid, -score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      ref.read(potProvider.notifier).potUpdate(score);
      break;
    case ActionTypeEnum.check:
      break;
  }
}

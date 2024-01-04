import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/action.dart';

class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playerDataProvider);
    final maxScore = findMaxInList(players.map((e) => e.score ?? 0).toList());
    if (maxScore == 0) {
      return Column(
        children: [
          ActionButton(actionTypeEnum: ActionTypeEnum.bet, maxScore: maxScore),
          ActionButton(
              actionTypeEnum: ActionTypeEnum.check, maxScore: maxScore),
          ActionButton(actionTypeEnum: ActionTypeEnum.fold, maxScore: maxScore)
        ],
      );
    } else {
      return Column(
        children: [
          ActionButton(
              actionTypeEnum: ActionTypeEnum.raise, maxScore: maxScore),
          ActionButton(actionTypeEnum: ActionTypeEnum.call, maxScore: maxScore),
          ActionButton(actionTypeEnum: ActionTypeEnum.fold, maxScore: maxScore)
        ],
      );
    }
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.actionTypeEnum,
    required this.maxScore,
  });

  final ActionTypeEnum actionTypeEnum;
  final int maxScore;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        switch (actionTypeEnum) {
          case ActionTypeEnum.fold:
            break;
          case ActionTypeEnum.call:
            break;
          case ActionTypeEnum.raise:
            break;
          case ActionTypeEnum.check:
            break;
          case ActionTypeEnum.bet:
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

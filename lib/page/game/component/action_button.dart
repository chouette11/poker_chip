import 'package:flutter/material.dart';
import 'package:poker_chip/util/enum/action.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.actionTypeEnum});
  final ActionTypeEnum actionTypeEnum;

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

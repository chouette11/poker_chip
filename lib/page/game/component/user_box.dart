import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class UserBoxes extends ConsumerWidget {
  const UserBoxes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<UserEntity> players = ref.watch(playerDataProvider);
    players.sort((a, b) => a.assignedId.compareTo(b.assignedId));
    final myAssignedId =
        players.firstWhere((e) => e.uid == ref.read(uidProvider)).assignedId;

    if (players.length == 1) {
      return const Text(
        '接続してください',
        style: TextStyle(fontSize: 32),
      );
    } else {
      players = rotateToMiddle(players, myAssignedId);
      print('players');
      print(players);
      final splitPlayers = splitArrayAroundTarget(players, myAssignedId);
      print(splitPlayers);
      final before = splitPlayers[0];
      final beforeUsers = before
          .map((e) => UserBox(
                name: e.name ?? '',
                stack: e.stack,
                score: e.score,
                isBtn: e.isBtn,
              ))
          .toList();
      final after = splitPlayers[1];
      final afterUsers = after
          .map((e) => UserBox(
                name: e.name ?? '',
                stack: e.stack,
                score: e.score,
                isBtn: e.isBtn,
              ))
          .toList();
      List<Widget> child = [];
      List<Widget> children = [];
      // playersが奇数の場合
      if (players.length % 2 == 1) {
        for (int i = 0; i < afterUsers.length; i++) {
          child.add(beforeUsers[i]);
          child.add(afterUsers[afterUsers.length - i]);
          children.add(SizedBox(height: 16));
          children.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: child,
          ));
        }
        return Column(children: children);
      } else {
        for (int i = 0; i < afterUsers.length; i++) {
          child.add(beforeUsers[i + 1]);
          child.add(afterUsers[afterUsers.length - i - 1]);
          children.add(SizedBox(height: 16));
          children.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: child,
          ));
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [beforeUsers[0]],
            ),
            ...children,
          ],
        );
      }
    }
  }
}

class UserBox extends StatelessWidget {
  const UserBox({
    super.key,
    required this.name,
    required this.stack,
    this.score,
    required this.isBtn,
  });

  final String name;
  final int stack;
  final int? score;
  final bool isBtn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 64,
          width: 100,
          decoration: const BoxDecoration(color: ColorConstant.black60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name, style: TextStyleConstant.bold14),
              Text(stack.toString(), style: TextStyleConstant.bold20),
            ],
          ),
        ),
        Text(score.toString() ?? ''),
        Visibility(visible: isBtn, child: Text('D'))
      ],
    );
  }
}

List<UserEntity> rotateToMiddle(List<UserEntity> users, int targetId) {
  int index = users.indexWhere((user) => user.assignedId == targetId);
  if (index != -1) {
    int midIndex = users.length ~/ 2; // 中央のインデックス
    int shift = index - midIndex; // 必要なシフト量

    if (shift > 0) {
      // targetを中央に移動するために右にシフト
      return users.sublist(shift) + users.sublist(0, shift);
    } else if (shift < 0) {
      // targetを中央に移動するために左にシフト
      return users.sublist(users.length + shift) +
          users.sublist(0, users.length + shift);
    }
  }
  return users;
}

List<List<UserEntity>> splitArrayAroundTarget(
    List<UserEntity> users, int target) {
  int index = users.indexWhere((user) => user.assignedId == target);

  if (index != -1) {
    // targetの前までの要素を含む配列
    final beforeTarget = users.sublist(0, index);

    // targetの後の要素を含む配列
    final afterTarget = users.sublist(index + 1);

    return [beforeTarget, afterTarget];
  } else {
    return [];
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/page/game/component/hole.dart';
import 'package:poker_chip/page/game/component/ranking_select_button.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';
import 'package:poker_chip/util/enum/game.dart';

class UserBoxes extends ConsumerWidget {
  const UserBoxes(this.isHost, {super.key});

  final bool isHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<UserEntity> players = ref.watch(playerDataProvider);
    players.sort((a, b) => b.assignedId.compareTo(a.assignedId));
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
      final before = splitPlayers[0];
      final beforeUsers =
          before.map((e) => UserBox(isHost: isHost, userEntity: e)).toList();
      final after = splitPlayers[1];
      final afterUsers =
          after.map((e) => UserBox(isHost: isHost, userEntity: e)).toList();
      List<Widget> child = [];
      List<Widget> children = [];
      // playersが奇数の場合
      if (players.length % 2 == 1) {
        for (int i = 0; i < afterUsers.length; i++) {
          child.add(beforeUsers[i]);
          child.add(afterUsers[afterUsers.length - i - 1]);
          children.add(const SizedBox(height: 16));
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
          children.add(const SizedBox(height: 16));
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

class UserBox extends ConsumerWidget {
  const UserBox({
    super.key,
    required this.isHost,
    required this.userEntity,
  });

  final bool isHost;
  final UserEntity userEntity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(roundProvider);
    final isSelected = ref.watch(isSelectedProvider(userEntity));
    final activeIds = ref
        .watch(playerDataProvider.notifier)
        .activePlayers()
        .map((e) => e.uid)
        .toList();
    final isSidePot = isHost
        ? ref.watch(hostSidePotsProvider).isNotEmpty
        : ref.watch(sidePotsProvider).isNotEmpty;
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
              Text(userEntity.name ?? 'プレイヤー1',
                  style: TextStyleConstant.bold14),
              Text(userEntity.stack.toString(),
                  style: TextStyleConstant.bold20),
            ],
          ),
        ),
        Row(
          children: [
            userEntity.isBtn ? const DearButton() : const SizedBox(width: 32),
            const SizedBox(width: 40),
            Visibility(
              visible: userEntity.score != 0,
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFFFE4C8),
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    userEntity.score.toString(),
                    style: TextStyleConstant.bold16
                        .copyWith(color: ColorConstant.black20),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
            const SizedBox(width: 32),
          ],
        ),
        Text('id: ${userEntity.assignedId}', style: TextStyleConstant.normal14),
        Visibility(visible: userEntity.isBtn, child: const Text('D')),
        Visibility(
          visible: round == GameTypeEnum.showdown &&
              activeIds.contains(userEntity.uid),
          child: isSidePot
              ? RankingSelectButton(userEntity)
              : Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    ref
                        .read(isSelectedProvider(userEntity).notifier)
                        .update((state) => !state);
                  },
                ),
        ),
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

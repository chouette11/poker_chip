import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';
import 'package:poker_chip/util/enum/game.dart';

class Hole extends ConsumerWidget {
  const Hole({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 自分のデータ
    final uid = ref.watch(uidProvider);
    final myData =
        ref.watch(playerDataProvider).firstWhere((e) => e.uid == uid);
    final round = ref.watch(roundProvider);
    final isSelected = ref.watch(isSelectedProvider(myData));
    final player = List.from(ref.read(playerDataProvider));
    player.removeWhere((e) => e.isFold == true);
    final activeIds = player.map((e) => e.uid).toList();

    return SizedBox(
      height: 220,
      child: Column(
        children: [
          Text(myData.score.toString()),
          Row(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/tranp.png',
                    height: 136,
                    width: 72,
                  ),
                  Image.asset(
                    'assets/images/tranp.png',
                    height: 136,
                    width: 72,
                  ),
                ],
              ),
              Visibility(
                visible: round == GameTypeEnum.showdown &&
                    activeIds.contains(myData.uid),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    ref
                        .read(isSelectedProvider(myData).notifier)
                        .update((state) => !state);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 64,
                width: 100,
                decoration: const BoxDecoration(color: ColorConstant.black60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(myData.name ?? 'プレイヤー1', style: TextStyleConstant.bold14),
                    Text(myData.stack.toString(), style: TextStyleConstant.bold20),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(raiseBetProvider.notifier).update((state) => 0);
                },
                child: Text('クリア'),
              )
            ],
          ),
        ],
      ),
    );
  }
}

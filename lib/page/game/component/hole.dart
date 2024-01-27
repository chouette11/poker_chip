import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/game/component/ranking_select_button.dart';
import 'package:poker_chip/page/game/host/component/host_action_button.dart';
import 'package:poker_chip/page/game/host/component/host_ranking_button.dart';
import 'package:poker_chip/page/game/host/component/host_who_win_button.dart';
import 'package:poker_chip/page/game/participant/component/participant_action_button.dart';
import 'package:poker_chip/page/game/participant/component/participant_ranking_button.dart';
import 'package:poker_chip/page/game/participant/component/participant_who_win_button.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation/pot.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';
import 'package:poker_chip/util/enum/game.dart';

class Hole extends ConsumerWidget {
  const Hole(this.isHost, {super.key});

  final bool isHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 自分のデータ
    final uid = ref.watch(uidProvider);
    final myData =
        ref.watch(playerDataProvider).firstWhere((e) => e.uid == uid);
    final round = ref.watch(roundProvider);
    final isSelected = ref.watch(isSelectedProvider(myData));
    final activeIds = ref
        .watch(playerDataProvider.notifier)
        .activePlayers()
        .map((e) => e.uid)
        .toList();
    final isSidePot = isHost
        ? ref.watch(hostSidePotsProvider).isNotEmpty
        : ref.watch(sidePotsProvider).isNotEmpty;

    return SizedBox(
      height: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          isHost ? const HostRankingButton() : const ParticipantRankingButton(),
          isHost ? const HostWhoWinButton() : const ParticipantWhoWinButton(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: isHost
                ? const HostActionButtons()
                : const ParticipantActionButtons(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 32),
              const SizedBox(width: 40),
              Visibility(
                visible: round == GameTypeEnum.showdown &&
                    activeIds.contains(myData.uid),
                child: isSidePot
                    ? RankingSelectButton(myData)
                    : Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          ref
                              .read(isSelectedProvider(myData).notifier)
                              .update((state) => !state);
                        },
                      ),
              ),
              Visibility(
                visible: myData.score != 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFE4C8),
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      myData.score.toString(),
                      style: TextStyleConstant.bold16
                          .copyWith(color: ColorConstant.black20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
              myData.isBtn ? const DealerButton() : const SizedBox(width: 32)
            ],
          ),
          const SizedBox(height: 16),
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
        ],
      ),
    );
  }
}

class DealerButton extends StatelessWidget {
  const DealerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: ColorConstant.black100,
        border: Border.all(width: 1, color: ColorConstant.black50),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: ColorConstant.black70, //色
            spreadRadius: 1,
            blurRadius: 0,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Center(
          child: Text(
        'D',
        style: TextStyleConstant.bold14.copyWith(color: Colors.black),
      )),
    );
  }
}

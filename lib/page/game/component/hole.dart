import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/page/game/component/ranking_select_button.dart';
import 'package:poker_chip/page/game/component/sit_button.dart';
import 'package:poker_chip/page/game/host/component/host_action_button.dart';
import 'package:poker_chip/page/game/host/component/host_ranking_button.dart';
import 'package:poker_chip/page/game/host/component/host_who_win_button.dart';
import 'package:poker_chip/page/game/participant/component/participant_action_button.dart';
import 'package:poker_chip/page/game/participant/component/participant_ranking_button.dart';
import 'package:poker_chip/page/game/participant/component/participant_who_win_button.dart';
import 'package:poker_chip/provider/presentation/peer.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation/pot.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/repository/user_repository.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/context_extension.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';

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
          Visibility(
            visible: myData.isSitOut && ref.watch(isSittingButtonProvider),
            child: SitButton(isHost: isHost),
          ),
          Visibility(
            visible: !myData.isSitOut,
            child: isHost
                ? const HostRankingButton()
                : const ParticipantRankingButton(),
          ),
          Visibility(
            visible: !myData.isSitOut,
            child: isHost
                ? const HostWhoWinButton()
                : const ParticipantWhoWinButton(),
          ),
          Visibility(
            visible: !myData.isSitOut,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: isHost
                  ? const HostActionButtons()
                  : const ParticipantActionButtons(),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 32),
              const SizedBox(height: 40, width: 40),
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
                      color: const Color(0xFFFFF636),
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      myData.score.toString(),
                      style: TextStyleConstant.score
                          .copyWith(color: ColorConstant.black20),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: myData.isCheck && myData.score == 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF636),
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Ch',
                      style: TextStyleConstant.score
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
          _EditablePlayerCard(isHost, myData),
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

class _EditablePlayerCard extends ConsumerWidget {
  const _EditablePlayerCard(this.isHost, this.myData, {super.key});

  final bool isHost;
  final UserEntity myData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final uid = ref.watch(uidProvider);
    final myData =
        ref.watch(playerDataProvider).firstWhere((e) => e.uid == uid);
    String playerName = '';
    int stack = 0;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: width * 0.6,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            onChanged: (value) {
                              playerName = value;
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              if (isHost) {
                                /// Hostの状態変更
                                ref
                                    .read(playerDataProvider.notifier)
                                    .updateName(uid, playerName);

                                /// Participantの状態変更
                                final user =
                                    myData.copyWith.call(name: playerName);
                                final mes = MessageEntity(
                                  type: MessageTypeEnum.userSetting,
                                  content: user,
                                );
                                ref.read(hostConsProvider.notifier).send(mes);
                              } else {
                                final conn = ref.read(participantConProvider);
                                final user =
                                    myData.copyWith.call(name: playerName);
                                final mes = MessageEntity(
                                  type: MessageTypeEnum.userSetting,
                                  content: user,
                                );
                                conn!.send(mes.toJson());
                              }
                              // 端末に保存
                              await ref
                                  .read(userRepositoryProvider)
                                  .saveName(playerName);
                              context.pop();
                            },
                            icon: const Icon(Icons.check)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: width * 0.6,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'Stack'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              stack = int.parse(value);
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (isHost) {
                                /// Hostの状態変更
                                ref
                                    .read(playerDataProvider.notifier)
                                    .changeStack(uid, stack);

                                /// Participantの状態変更
                                final user = myData.copyWith.call(stack: stack);
                                final mes = MessageEntity(
                                  type: MessageTypeEnum.userSetting,
                                  content: user,
                                );
                                ref.read(hostConsProvider.notifier).send(mes);
                              } else {
                                final conn = ref.read(participantConProvider);
                                final user = myData.copyWith.call(stack: stack);
                                final mes = MessageEntity(
                                  type: MessageTypeEnum.userSetting,
                                  content: user,
                                );
                                conn!.send(mes.toJson());
                              }
                              context.pop();
                            },
                            icon: const Icon(Icons.check)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 64,
        width: 100,
        decoration: const BoxDecoration(color: ColorConstant.black60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(myData.name ?? context.l10n.playerX(1),
                style: TextStyleConstant.bold14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(myData.stack.toString(), style: TextStyleConstant.bold20),
                const SizedBox(
                  height: 20,
                  child: Icon(
                    Icons.edit,
                    color: ColorConstant.black100,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

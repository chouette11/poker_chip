import 'dart:typed_data';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/component/ad/banner_ad.dart';
import 'package:poker_chip/page/game/component/chips.dart';
import 'package:poker_chip/page/game/component/hand_button.dart';
import 'package:poker_chip/page/game/component/hole.dart';
import 'package:poker_chip/page/game/component/info.dart';
import 'package:poker_chip/page/game/component/pot.dart';
import 'package:poker_chip/page/game/host/host_page.dart';
import 'package:poker_chip/page/game/participant/component/id_text_field.dart';
import 'package:poker_chip/page/game/component/user_box.dart';
import 'package:poker_chip/provider/presentation/opt_id.dart';
import 'package:poker_chip/provider/presentation/peer.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation/pot.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';

class ParticipantPage extends ConsumerStatefulWidget {
  const ParticipantPage({Key? key, required this.id}) : super(key: key);
  final String? id;

  @override
  ConsumerState<ParticipantPage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<ParticipantPage> {
  Peer peer = Peer(options: PeerOptions(debug: LogLevel.All));
  bool isChanged = false;
  late DataConnection conn;
  MessageEntity preMes =
      const MessageEntity(type: MessageTypeEnum.game, content: 'content');
  bool connected = false;

  @override
  void dispose() {
    peer.dispose();
    super.dispose();
  }

  void connect(WidgetRef ref) {
    context.loaderOverlay.show();
    Future.delayed(const Duration(seconds: 2), () {
      context.loaderOverlay.hide();
    });
    final roomId = int.parse(ref.read(idTextFieldControllerProvider).text);
    final peerId = roomToPeerId(roomId);
    final connection = peer.connect(widget.id ?? peerId);
    ref.read(participantConProvider.notifier).update((state) => connection);
    ref.read(errorTextProvider.notifier).view();
    conn = connection;
    print('con!');

    conn.on("open").listen((event) {
      print('open!');
      setState(() {
        connected = true;
        context.loaderOverlay.hide();
        ref.read(isJoinProvider.notifier).update((state) => true);
      });

      connection.on("close").listen((event) {
        setState(() {
          connected = false;
        });
        peer = Peer(options: PeerOptions(debug: LogLevel.All));
        Future.delayed(const Duration(seconds: 2), () {
          connect(ref);
        });
      });

      conn.on("data").listen((data) {
        final uid = ref.read(uidProvider);
        final mes = MessageEntity.fromJson(data);
        if (mes == preMes) {
          return;
        }
        preMes = mes;
        print('paticipant: $mes');
        if (mes.type == MessageTypeEnum.joined) {
          final data = mes.content as List;
          final users = data.map((e) => UserEntity.fromJson(e)).toList();
          for (final user in users) {
            if (user.uid != uid) {
              ref.read(playerDataProvider.notifier).add(user);
            } else {
              ref.read(playerDataProvider.notifier).update(user);
            }
          }
        } else if (mes.type == MessageTypeEnum.userSetting) {
          final user = UserEntity.fromJson(mes.content);
          ref.read(playerDataProvider.notifier).update(user);
        } else if (mes.type == MessageTypeEnum.action) {
          final action = ActionEntity.fromJson(mes.content);
          _participantActionMethod(action, ref);
          ref
              .read(participantOptIdProvider.notifier)
              .update((state) => action.optId ?? 0);
        } else if (mes.type == MessageTypeEnum.game) {
          final game = GameEntity.fromJson(mes.content);
          _gameMethod(game, ref);
        }
      });
      conn.on("binary").listen((data) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Got binary!")));
      });
    });
  }

  void sendHelloWorld() {
    conn.send('{"text":"Hello"}');
    print('hello');
  }

  void sendBinary() {
    final bytes = Uint8List(30);
    conn.sendBinary(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final flavor = ref.watch(flavorProvider);
    final isStart = ref.watch(isStartProvider);
    final isJoin = ref.watch(isJoinProvider);

    ref.listen(isJoinProvider, (previous, next) {
      if (next) {
        Future.delayed(const Duration(seconds: 1), () {
          final uid = ref.read(uidProvider);
          final mes = MessageEntity(
            type: MessageTypeEnum.join,
            content: UserEntity(
              uid: uid,
              assignedId: 404,
              name: ref.watch(nameProvider),
              stack: ref.watch(stackProvider),
              score: 0,
              isBtn: false,
              isAction: false,
              isFold: false,
              isCheck: false,
              isSitOut: false,
            ),
          );
          conn.send(mes.toJson());
        });
      }
    });
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstant.back,
        body: SafeArea(
          child: LoaderOverlay(
            overlayWholeScreen: false,
            overlayWidth: 128,
            overlayHeight: 128,
            overlayColor: ColorConstant.black80.withOpacity(0.5),
            child: Column(
              children: [
                BannerAdWidget(width: width, height: height * 0.06),
                Expanded(
                  child: SizedBox(
                    width: width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Image.asset(
                            'assets/images/board.png',
                            fit: BoxFit.fill,
                            height: height - 36,
                            width: width,
                          ),
                        ),
                        const Positioned(
                          bottom: 16,
                          right: 16,
                          child: HandButton(),
                        ),
                        const Positioned(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: UserBoxes(false),
                          ),
                        ),
                        Positioned(
                          top: height * 0.25,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: PotWidget(false),
                          ),
                        ),
                        Visibility(
                          visible: isStart,
                          child: Positioned(
                            top: height * 0.35,
                            child: const InfoWidget(false),
                          ),
                        ),
                        Visibility(
                          visible: !isStart && isJoin,
                          child: Positioned(
                            top: height * 0.4,
                            child: const Text(
                              'ホストが開始するまでお待ち下さい',
                              style: TextStyleConstant.normal14,
                            ),
                          ),
                        ),
                        // Positioned(
                        //   child: Image.asset(
                        //     'assets/images/chips.png',
                        //     fit: BoxFit.fitHeight,
                        //     height: 200,
                        //     width: 200,
                        //   ),
                        // ),
                        IdTextField((ref) => connect(ref)),
                        Positioned(
                            bottom: height * 0.2, child: const Hole(false)),
                        Visibility(
                          visible: flavor == 'dev',
                          child: Positioned(
                              bottom: height * 0.17,
                              child: Text(connected.toString())),
                        ),
                        Positioned(
                            bottom: height * 0.08, left: 0, child: const Chips()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _participantActionMethod(ActionEntity action, WidgetRef ref) {
  final type = action.type;
  final uid = action.uid;
  final score = action.score;
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
      ref.read(playerDataProvider.notifier).updateCheck(uid);
      break;
  }
}

void _gameMethod(GameEntity game, WidgetRef ref) {
  final type = game.type;
  final uid = game.uid;
  final score = game.score;
  final playerNotifier = ref.read(playerDataProvider.notifier);
  switch (type) {
    case GameTypeEnum.blind:
      playerNotifier.updateStack(uid, -score);
      playerNotifier.updateScore(uid, score);
      ref.read(potProvider.notifier).potUpdate(score);
      ref.read(isStartProvider.notifier).update((state) => true);
      break;
    case GameTypeEnum.anty:
      break;
    case GameTypeEnum.ranking:
      break;
    case GameTypeEnum.btn:
      playerNotifier.updateBtn(uid);
      break;
    case GameTypeEnum.sidePot:
      print(score);
      ref.read(sidePotsProvider.notifier).addSidePot(score);
      break;
    case GameTypeEnum.preFlop:
      ref.read(roundProvider.notifier).update(type);
      if (score != 0) {
        ref.read(participantOptIdProvider.notifier).update((state) => score);
      }
      ref.read(potProvider.notifier).clear();
      ref.read(sidePotsProvider.notifier).clear();
      playerNotifier.clearIsFold();
      break;
    case GameTypeEnum.flop:
      ref.read(roundProvider.notifier).update(type);
      playerNotifier.clearScore();
      playerNotifier.clearIsCheck();
      break;
    case GameTypeEnum.turn:
      ref.read(roundProvider.notifier).update(type);
      playerNotifier.clearScore();
      playerNotifier.clearIsCheck();
      break;
    case GameTypeEnum.river:
      ref.read(roundProvider.notifier).update(type);
      playerNotifier.clearScore();
      playerNotifier.clearIsCheck();
      break;
    case GameTypeEnum.foldout:
      ref.read(roundProvider.notifier).update(type);
      playerNotifier.clearScore();
      playerNotifier.clearIsCheck();
      playerNotifier.updateStack(uid, score);
    case GameTypeEnum.showdown:
      ref.read(roundProvider.notifier).update(type);
      playerNotifier.clearScore();
      playerNotifier.clearIsCheck();
      if (uid != '') {
        playerNotifier.updateStack(uid, score);
      }
      break;
  }
}

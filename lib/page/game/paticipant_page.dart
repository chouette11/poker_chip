import 'dart:convert';
import 'dart:typed_data';

import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/game/component/chips.dart';
import 'package:poker_chip/page/game/component/hole.dart';
import 'package:poker_chip/page/game/component/participant_action_button.dart';
import 'package:poker_chip/page/game/component/pot.dart';
import 'package:poker_chip/page/game/component/user_box.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';

class ParticipantPage extends ConsumerStatefulWidget {
  const ParticipantPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  ConsumerState<ParticipantPage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<ParticipantPage> {
  Peer peer = Peer(options: PeerOptions(debug: LogLevel.All));
  bool isChanged = false;
  late DataConnection conn;
  bool connected = false;

  @override
  void dispose() {
    peer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Timer.periodic(Duration(milliseconds: 1500), (timer) {
    //   print('timer');
    //   // connect();
    //   if (connected) {
    //     timer.cancel();
    //     final uid = ref.read(uidProvider);
    //     final mes = MessageEntity(
    //       type: 'join',
    //       content: UserEntity(
    //         uid: uid,
    //         assignedId: 404,
    //         name: null,
    //         stack: 1000,
    //         isBtn: false,
    //       ),
    //     );
    //     conn.send(jsonEncode(mes.toJson()));
    //     print('send');
    //     print(mes.toJson().toString());
    //   }
    // });
  }

  void connect(WidgetRef ref) {
    final connection = peer.connect(widget.id);
    ref.read(participantConProvider.notifier).update((state) => connection);
    conn = connection;
    print('con!');

    conn.on("open").listen((event) {
      print('open!');
      setState(() {
        connected = true;
      });

      connection.on("close").listen((event) {
        setState(() {
          connected = false;
        });
      });

      conn.on("data").listen((data) {
        final uid = ref.read(uidProvider);
        final mes = MessageEntity.fromJson(data);
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final uid = ref.read(uidProvider);
            final mes = MessageEntity(
              type: MessageTypeEnum.join,
              content: UserEntity(
                uid: uid,
                assignedId: 404,
                name: null,
                stack: 1000,
                score: 0,
                isBtn: false,
                isAction: false,
                isFold: false,
              ),
            );
            conn.send(mes.toJson());
            print('send');
            print(mes.toJson());
          },
        ),
        backgroundColor: ColorConstant.back,
        body: SafeArea(
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/board.png',
                    fit: BoxFit.fitHeight,
                    height: height - 36,
                    width: width,
                  ),
                ),
                const Positioned(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: UserBoxes(),
                  ),
                ),
                Positioned(
                  height: height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ref.watch(roundProvider).name),
                  ),
                ),
                Positioned(
                  height: height * 0.4,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PotWidget(),
                  ),
                ),
                Positioned(
                  height: height * 0.4,
                  right: width * 0.2,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ParticipantActionButtons(),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => connect(ref), child: Text('con')),
                // Positioned(
                //   child: Image.asset(
                //     'assets/images/chips.png',
                //     fit: BoxFit.fitHeight,
                //     height: 200,
                //     width: 200,
                //   ),
                // ),
                Positioned(bottom: height * 0.2, child: const Hole()),
                Positioned(
                    bottom: height * 0.2, child: Text(connected.toString())),
                Positioned(bottom: height * 0.1, left: 0, child: const Chips()),
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
  final maxScore = action.score;
  final score = ref.read(raiseBetProvider);
  ref.read(playerDataProvider.notifier).updateAction(uid);
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

void _gameMethod(GameEntity game, WidgetRef ref) {
  final type = game.type;
  final uid = game.uid;
  final myUid = ref.read(uidProvider);
  final score = game.score;
  switch (type) {
    case GameTypeEnum.blind:
      ref.read(playerDataProvider.notifier).updateStack(uid, score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      break;
    case GameTypeEnum.anty:
      break;
    case GameTypeEnum.btn:
      ref.read(playerDataProvider.notifier).updateBtn(uid);
      break;
    case GameTypeEnum.pot:
      break;
    case GameTypeEnum.preFlop:
      ref.read(roundProvider.notifier).update(type);
      ref.read(potProvider.notifier).clear();
      ref.read(playerDataProvider.notifier).clearIsFold();
      break;
    case GameTypeEnum.flop:
      ref.read(roundProvider.notifier).update(type);
      ref.read(potProvider.notifier).scoreSumToPot();
      ref.read(playerDataProvider.notifier).clearScore();
      break;
    case GameTypeEnum.turn:
      ref.read(roundProvider.notifier).update(type);
      ref.read(potProvider.notifier).scoreSumToPot();
      ref.read(playerDataProvider.notifier).clearScore();
      break;
    case GameTypeEnum.river:
      ref.read(roundProvider.notifier).update(type);
      ref.read(potProvider.notifier).scoreSumToPot();
      ref.read(playerDataProvider.notifier).clearScore();
      break;
    case GameTypeEnum.foldout:
      ref.read(roundProvider.notifier).update(type);
      ref.read(potProvider.notifier).scoreSumToPot();
      ref.read(playerDataProvider.notifier).clearScore();
      final pot = ref.read(potProvider);
      ref.read(playerDataProvider.notifier).updateStack(uid, pot);
      if (uid == myUid) {
        ref.read(isWinProvider.notifier).update((state) => true);
      }
    case GameTypeEnum.showdown:
      ref.read(roundProvider.notifier).update(type);
      ref.read(potProvider.notifier).scoreSumToPot();
      ref.read(playerDataProvider.notifier).clearScore();
      if (score == 1) {
        ref.read(isFinalProvider.notifier).update((state) => true);
      }
      break;
  }
}

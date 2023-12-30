import 'dart:convert';
import 'dart:typed_data';

import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/game/component/chips.dart';
import 'package:poker_chip/page/game/component/hole.dart';
import 'package:poker_chip/page/game/component/user_box.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/enum/action.dart';

class ParticipantPage extends ConsumerStatefulWidget {
  const ParticipantPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  ConsumerState<ParticipantPage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<ParticipantPage> {
  bool isChanged = false;
  Peer peer = Peer(options: PeerOptions(debug: LogLevel.All));
  late DataConnection conn;
  bool connected = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1));
    connect();
    super.initState();
  }

  void connect() {
    final connection = peer.connect(widget.id);
    conn = connection;

    conn.on("open").listen((event) {
      setState(() {
        connected = true;
      });
      final uid = ref.read(uidProvider);
      final mes = MessageEntity(
        type: 'join',
        content: UserEntity(
          uid: uid,
          assignedId: 404,
          name: null,
          stack: 1000,
          isBtn: false,
        ),
      );
      conn.send(jsonEncode(mes.toJson()));

      connection.on("close").listen((event) {
        setState(() {
          connected = false;
        });
      });

      conn.on("data").listen((data) {
        final mes = MessageEntity.fromJson(data);
        print('paticipant: $mes');
        if (mes.type == 'joined') {
          final user = UserEntity.fromJson(mes.content);
          if (user.uid != uid) {
            ref.read(playerDataProvider.notifier).add(user);
          } else {
            ref.read(playerDataProvider.notifier).update(user);
          }
        } else if (mes.type == 'action') {
          final action = ActionEntity.fromJson(mes.content);
          actionMethod(action, ref);
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

  void closeConnection() {
    peer.dispose();
  }

  void reconnect() {
    peer = Peer();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => connect(),
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

void actionMethod(ActionEntity action, WidgetRef ref) {
  final type = action.type;
  final uid = action.uid!;
  final score = action.score;
  switch (type) {
    case ActionTypeEnum.fold:
      break;
    case ActionTypeEnum.call:
      ref.read(playerDataProvider.notifier).updateStack(uid, score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
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
    case ActionTypeEnum.pot:
      break;
    case ActionTypeEnum.anty:
      break;
    case ActionTypeEnum.blind:
      ref.read(playerDataProvider.notifier).updateStack(uid, score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      break;
    case ActionTypeEnum.btn:
      ref.read(playerDataProvider.notifier).updateBtn(uid);
      break;
  }
}

import 'dart:typed_data';

import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/page/game/component/chips.dart';
import 'package:poker_chip/page/game/component/hole.dart';
import 'package:poker_chip/page/game/component/qr_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/game/component/user_box.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';

class HostPage extends ConsumerStatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HostPage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<HostPage> {
  bool isChanged = false;
  Peer peer = Peer(options: PeerOptions(debug: LogLevel.All));
  final TextEditingController _controller = TextEditingController();
  String? peerId;
  late DataConnection conn;
  bool connected = false;

  @override
  void dispose() {
    peer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    peer.on("open").listen((id) {
      setState(() {
        peerId = peer.id;
      });
      print(peer.id);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog(
            context: context, builder: (context) => QrDialog(peer.id ?? ''));
      });
    });

    peer.on("close").listen((id) {
      setState(() {
        connected = false;
      });
    });

    peer.on<DataConnection>("connection").listen((event) {
      conn = event;

      conn.on("data").listen((data) {
        print(data);
        final mes = data as MessageEntity;
        print('host: $mes');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mes.type)));
        if (mes.type == 'join') {
          UserEntity user = mes.content as UserEntity;
          final others = ref.read(othersDataProvider);
          user = UserEntity(
            uid: user.uid,
            name: user.name ?? 'プレイヤー${others.length + 2}',
            stack: user.stack,
          );
          ref.read(othersDataProvider.notifier).update((state) => [
                ...state,
                user,
              ]);
          final res = MessageEntity(type: 'joined', content: user);
          conn.send(res.toJson());
          final uid = ref.read(uidProvider);
          conn.send(MessageEntity(
                  type: 'host',
                  content: UserEntity(uid: uid, name: 'プレイヤー1', stack: 1000))
              .toJson());
        }
      });

      conn.on("binary").listen((data) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Got binary")));
      });

      conn.on("close").listen((event) {
        setState(() {
          connected = false;
        });
      });

      setState(() {
        connected = true;
      });
    });
  }

  void sendHelloWorld() {
    conn.send('{"text":"Hello"}');
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
                  child: Image.asset(
                    'assets/images/chips.png',
                    fit: BoxFit.fitHeight,
                    height: 200,
                    width: 200,
                  ),
                ),
                Positioned(bottom: height * 0.2, child: const Hole()),
                Positioned(bottom: height * 0.2, child:  Text(connected.toString())),
                Positioned(bottom: height * 0.1, left: 0, child: const Chips()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/page/game/component/chips.dart';
import 'package:poker_chip/page/game/component/hole.dart';
import 'package:poker_chip/page/game/component/pot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/game/component/user_box.dart';
import 'package:poker_chip/page/game/paticipant_page.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/host.dart';

class HostPage extends ConsumerStatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HostPage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<HostPage> {
  bool isChanged = false;
  final TextEditingController _controller = TextEditingController();
  String? peerId;
  bool connected = false;

  @override
  void dispose() {
    final peer = ref.read(peerProvider);
    peer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final peer = ref.read(peerProvider);
    ref.read(isConnProvider(peer).notifier).open(context);
  }

  void sendHelloWorld(DataConnection conn) {
    conn.send('{"text":"Hello"}');
  }

  void game(DataConnection conn) {
    final smallId = ref.read(smallIdProvider);
    final bigId = ref.read(bigIdProvider);
    final btnId = ref.read(btnIdProvider);
    final smallBlind = MessageEntity(
      type: HostMessageTypeEnum.action.name,
      content: ActionEntity(
        uid: assignedIdToUid(smallId, ref),
        type: ActionTypeEnum.blind,
        score: 10,
      ),
    );
    final bigBlind = MessageEntity(
      type: HostMessageTypeEnum.action.name,
      content: ActionEntity(
        uid: assignedIdToUid(bigId, ref),
        type: ActionTypeEnum.blind,
        score: 20,
      ),
    );
    final btn = MessageEntity(
      type: HostMessageTypeEnum.action.name,
      content: ActionEntity(
          uid: assignedIdToUid(btnId, ref), type: ActionTypeEnum.btn, score: 0),
    );
    conn.send(smallBlind.toJson());
    actionMethod(
      ActionEntity(
        uid: assignedIdToUid(smallId, ref),
        type: ActionTypeEnum.blind,
        score: 10,
      ),
      ref,
    );
    conn.send(bigBlind.toJson());
    actionMethod(
      ActionEntity(
        uid: assignedIdToUid(bigId, ref),
        type: ActionTypeEnum.blind,
        score: 20,
      ),
      ref,
    );
    actionMethod(
      ActionEntity(uid: assignedIdToUid(btnId, ref), type: ActionTypeEnum.btn, score: 0),
      ref,
    );
    conn.send(btn.toJson());
  }

  void closeConnection() {
    final peer = ref.read(peerProvider);
    peer.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final score = ref.watch(scoreProvider);
    final conn = ref.watch(conProvider(''));

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
                  height: height * 0.4,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PotWidget(score: score),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    game(conn);
                  },
                  child: const Text('ブラインド'),
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

String assignedIdToUid(int assignedId, WidgetRef ref) {
  final players = ref.read(playerDataProvider);
  return players.firstWhere((e) => e.assignedId == assignedId).uid;
}

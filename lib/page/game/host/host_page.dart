import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/peer/peer_con_entity.dart';
import 'package:poker_chip/page/game/component/chips.dart';
import 'package:poker_chip/page/game/component/hole.dart';
import 'package:poker_chip/page/game/host/component/host_action_button.dart';
import 'package:poker_chip/page/game/host/component/host_ranking_button.dart';
import 'package:poker_chip/page/game/host/component/host_side_pots.dart';
import 'package:poker_chip/page/game/host/component/host_who_win_button.dart';
import 'package:poker_chip/page/game/host/component/host_pot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/game/component/user_box.dart';
import 'package:poker_chip/provider/presentation/host_conn_open.dart';
import 'package:poker_chip/provider/presentation/opt_id.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';

class HostPage extends ConsumerStatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HostPage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<HostPage> {
  bool isChanged = false;
  final TextEditingController _controller = TextEditingController();
  bool connected = false;

  @override
  void dispose() {
    final players = ref.read(playerDataProvider);
    final id = lenToPeerId(players.length);
    final peer = ref.read(peerProvider(id));
    peer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final players = ref.read(playerDataProvider);
    final id = lenToPeerId(players.length);

    final peer = ref.read(peerProvider(id));
    ref.read(hostConnOpenProvider(peer).notifier).open(context);
  }

  void sendHelloWorld(DataConnection conn) {
    conn.send('{"text":"Hello"}');
  }

  void closeConnection(String id) {
    final peer = ref.read(peerProvider(id));
    peer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final len = ref.watch(playerDataProvider).length;
    final cons = ref.watch(hostConsProvider);
    final peer = ref.watch(peerProvider(lenToPeerId(len)));
    ref.listen(playerDataProvider, (previous, next) {
      final id = lenToPeerId(next.length);
      final peer = ref.read(peerProvider(id));
      ref.read(hostConnOpenProvider(peer).notifier).open(context);
    });

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
                  height: height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ref.watch(roundProvider).name),
                  ),
                ),
                Positioned(
                  height: height * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('optId:${ref.watch(optionAssignedIdProvider)}'),
                  ),
                ),
                Positioned(
                  height: height * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HostPotWidget(),
                  ),
                ),
                Positioned(
                  height: height * 0.4,
                  left: width * 0.3,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HostSidePotsWidget(),
                  ),
                ),
                Positioned(
                  height: height * 0.4,
                  right: width * 0.2,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HostWhoWinButton(),
                  ),
                ),
                Positioned(
                  height: height * 0.4,
                  right: width * 0.2,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HostRankingButton(),
                  ),
                ),
                Positioned(
                  height: height * 0.4,
                  right: width * 0.2,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HostActionButtons(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _game(cons, ref);
                  },
                  child: const Text('ブラインド'),
                ),
                Text(peer.id ?? ''),
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
  if (!players.map((e) => e.assignedId).toList().contains(assignedId)) {
    return '';
  }
  return players.firstWhere((e) => e.assignedId == assignedId).uid;
}

String lenToPeerId(int len) {
  final ids = [
    'c78da73a-9b97-4efc-9303-4161de32b84f',
    '5f865cf4-02d2-4249-812e-d0c5d8eecad3',
    '3'
  ];
  return ids[len - 1];
}

void _game(List<PeerConEntity> cons, WidgetRef ref) {
  if (ref.read(playerDataProvider).length == 2) {
    ref.read(bigIdProvider.notifier).fixHeads();
    ref.read(btnIdProvider.notifier).fixHeads();
    ref.read(smallIdProvider.notifier).fixHeads();
  }
  final smallId = ref.read(smallIdProvider);
  final bigId = ref.read(bigIdProvider);
  final btnId = ref.read(btnIdProvider);
  const big = 20;
  const small = 10;
  final smallBlind = MessageEntity(
    type: MessageTypeEnum.game,
    content: GameEntity(
      uid: assignedIdToUid(smallId, ref),
      type: GameTypeEnum.blind,
      score: small,
    ),
  );
  final bigBlind = MessageEntity(
    type: MessageTypeEnum.game,
    content: GameEntity(
      uid: assignedIdToUid(bigId, ref),
      type: GameTypeEnum.blind,
      score: big,
    ),
  );
  final btn = MessageEntity(
    type: MessageTypeEnum.game,
    content: GameEntity(
        uid: assignedIdToUid(btnId, ref), type: GameTypeEnum.btn, score: 0),
  );

  /// Participantの状態変更
  for (var conEntity in cons) {
    final conn = conEntity.con;
    conn.send(smallBlind.toJson());
    conn.send(bigBlind.toJson());
    conn.send(btn.toJson());
  }

  /// Hostの状態変更
  ref
      .read(playerDataProvider.notifier)
      .updateStack(assignedIdToUid(smallId, ref), -small);
  ref
      .read(playerDataProvider.notifier)
      .updateScore(assignedIdToUid(smallId, ref), small);
  ref
      .read(playerDataProvider.notifier)
      .updateStack(assignedIdToUid(bigId, ref), -big);
  ref
      .read(playerDataProvider.notifier)
      .updateScore(assignedIdToUid(bigId, ref), big);
  ref.read(playerDataProvider.notifier).updateBtn(assignedIdToUid(btnId, ref));
  ref.read(potProvider.notifier).potUpdate(small + big);
}

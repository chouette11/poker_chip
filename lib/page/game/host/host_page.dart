import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/peer/peer_con_entity.dart';
import 'package:poker_chip/page/game/component/chips.dart';
import 'package:poker_chip/page/game/component/hole.dart';
import 'package:poker_chip/page/game/component/side_pot.dart';
import 'package:poker_chip/page/game/host/component/host_action_button.dart';
import 'package:poker_chip/page/game/host/component/host_ranking_button.dart';
import 'package:poker_chip/page/game/host/component/host_who_win_button.dart';
import 'package:poker_chip/page/game/component/pot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/game/component/user_box.dart';
import 'package:poker_chip/page/game/host/component/room_id.dart';
import 'package:poker_chip/provider/presentation/host_conn_open.dart';
import 'package:poker_chip/provider/presentation/opt_id.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';
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
    final roomId = ref.read(roomIdProvider);
    final id = roomToPeerId(roomId);
    final peer = ref.read(peerProvider(id));
    peer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final roomId = ref.read(roomIdProvider);
    final id = roomToPeerId(roomId);

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
    final cons = ref.watch(hostConsProvider);
    final flavor = ref.watch(flavorProvider);
    final isStart = ref.watch(isStartProvider);

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
                    child: UserBoxes(true),
                  ),
                ),
                Positioned(
                  top: height * 0.23,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ref.watch(roundProvider).name,
                      style: TextStyleConstant.bold16,
                    ),
                  ),
                ),
                Visibility(
                  visible: flavor == 'dev',
                  child: Positioned(
                    height: height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('optId:${ref.watch(optionAssignedIdProvider)}'),
                    ),
                  ),
                ),
                Visibility(
                  visible: isStart,
                  child: Positioned(
                    top: height * 0.3,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: PotWidget(true),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.3,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: RoomIdWidget(),
                  ),
                ),
                Positioned(
                  top: height * 0.3,
                  left: width * 0.3,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SidePotsWidget(true),
                  ),
                ),
                Positioned(
                  top: height * 0.3,
                  right: width * 0.2,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HostWhoWinButton(),
                  ),
                ),
                Positioned(
                  top: height * 0.3,
                  right: width * 0.2,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HostRankingButton(),
                  ),
                ),
                Positioned(
                  top: height * 0.3,
                  right: width * 0.2,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HostActionButtons(),
                  ),
                ),
                Visibility(
                  visible: !isStart,
                  child: Positioned(
                    top: height * 0.4,
                    child: ElevatedButton(
                      onPressed: () {
                        _game(cons, ref);
                      },
                      child: const Text('スタート'),
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
                Visibility(
                  visible: !isStart,
                  child: Positioned(
                    top: height * 0.5,
                    child: const Text(
                      '全員が揃ったら開始してください',
                      style: TextStyleConstant.normal16,
                    ),
                  ),
                ),
                Positioned(bottom: height * 0.17, child: const Hole(true)),
                Visibility(
                  visible: flavor == 'dev',
                  child: Positioned(
                      bottom: height * 0.17, child: Text(connected.toString())),
                ),
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

String roomToPeerId(int roomId) {
  return '$roomId--chouette111-poker-chip';
}

void _game(List<PeerConEntity> cons, WidgetRef ref) {
  ref.read(isStartProvider.notifier).update((state) => true);
  final bigId = ref.read(bigIdProvider);
  final smallId = ref.read(bigIdProvider.notifier).smallId();
  final btnId = ref.read(bigIdProvider.notifier).btnId();
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

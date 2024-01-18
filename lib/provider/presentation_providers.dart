import 'dart:async';

import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/peer/peer_con_entity.dart';
import 'package:poker_chip/model/entity/side_pot/side_pot_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/domain_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'presentation_providers.g.dart';

final uidProvider = StateProvider<String>((ref) =>
    ref.read(firebaseAuthProvider).currentUser?.uid ?? const Uuid().v4());

final qrCodeDataProvider = StateProvider<String>((ref) => '');

final raiseBetProvider = StateProvider((ref) => 0);

final stackProvider = StateProvider((ref) => 1000);

final playersExProvider = StateProvider((ref) => []);

///
/// Peer
///

final peerProvider = ProviderFamily((ref, String id) => Peer(id: id));

final participantConProvider = StateProvider<DataConnection?>((ref) => null);

@riverpod
class HostCons extends _$HostCons {
  @override
  List<PeerConEntity> build() {
    return [];
  }

  void add(PeerConEntity peerConEntity) {
    state = [...state, peerConEntity];
  }
}


///
/// Game
///

final isSelectedProvider =
    StateProvider.family((ref, UserEntity user) => false);

@riverpod
class HostSidePots extends _$HostSidePots {
  @override
  List<SidePotEntity> build() {
    return [];
  }

  void addSidePots(List<SidePotEntity> sidePots) {
    state = [...state, ...sidePots];
  }

  void clear() {
    state = [];
  }
}

@riverpod
class Ranking extends _$Ranking {
  @override
  List<List<String>> build() {
    return [];
  }

  void addUserUids(List<String> uids) {
    state = [...state, uids];
  }

  int selectedLength() {
    int length = 0;
    for (final uids in state) {
      for (final _ in uids) {
        length = length + 1;
      }
    }
    return length;
  }
}

@riverpod
class SidePots extends _$SidePots {
  @override
  List<int> build() {
    return [];
  }

  void addSidePot(int sidePotValue) {
    state = [...state, sidePotValue];
  }

  int totalValue() {
    int value = 0;
    for (final pot in state) {
      value += pot;
    }
    return value;
  }

  void clear() {
    state = [];
  }
}

@riverpod
class Pot extends _$Pot {
  @override
  int build() {
    return 0;
  }

  void potUpdate(int score) {
    state = state + score;
  }

  void clear() {
    state = 0;
  }
}

@riverpod
class Round extends _$Round {
  @override
  GameTypeEnum build() {
    return GameTypeEnum.preFlop;
  }

  void nextRound() {
    switch (state) {
      case GameTypeEnum.preFlop:
        state = GameTypeEnum.flop;
      case GameTypeEnum.flop:
        state = GameTypeEnum.turn;
      case GameTypeEnum.turn:
        state = GameTypeEnum.river;
      case GameTypeEnum.river:
        state = GameTypeEnum.showdown;
      case GameTypeEnum.showdown:
        break;
      case GameTypeEnum.foldout:
        break;
      case GameTypeEnum.blind:
        break;
      case GameTypeEnum.anty:
        break;
      case GameTypeEnum.btn:
        break;
      case GameTypeEnum.sidePot:
    }
  }

  void update(GameTypeEnum gameTypeEnum) {
    state = gameTypeEnum;
  }

  void delayPreFlop() {
    Future.delayed(Duration(seconds: 3), () {
      /// foldを初期化
      ref.read(playerDataProvider.notifier).clearIsFold();

      /// potを初期化
      ref.read(potProvider.notifier).clear();
      ref.read(hostSidePotsProvider.notifier).clear();
      ref.read(sidePotsProvider.notifier).clear();
      state = GameTypeEnum.preFlop;
    });

    Future.delayed(Duration(seconds: 6), () {
      final cons = ref.read(hostConsProvider);
      _game(cons, ref);
    });
  }
}

///
/// position
///

@Riverpod(keepAlive: true)
class BtnId extends _$BtnId {
  @override
  int build() {
    return 1;
  }

  void updateId() {
    final len = ref.read(playerDataProvider).length;
    if ((state + 1) > len) {
      state = 1;
    } else {
      state = state + 1;
    }
  }

  void fixHeads() {
    state = 1;
  }
}

@Riverpod(keepAlive: true)
class SmallId extends _$SmallId {
  @override
  int build() {
    return 2;
  }

  void updateId() {
    final len = ref.read(playerDataProvider).length;
    if ((state + 1) > len) {
      state = 1;
    } else {
      state = state + 1;
    }
  }

  void fixHeads() {
    state = 1;
  }
}

@Riverpod(keepAlive: true)
class BigId extends _$BigId {
  @override
  int build() {
    return 3;
  }

  void updateId() {
    final len = ref.read(playerDataProvider).length;
    if ((state + 1) > len) {
      state = 1;
    } else {
      state = state + 1;
    }
  }

  void fixHeads() {
    state = 2;
  }
}

void _game(List<PeerConEntity> cons,
    AutoDisposeNotifierProviderRef<GameTypeEnum> ref) {
  final smallId = ref.read(smallIdProvider);
  final bigId = ref.read(bigIdProvider);
  final btnId = ref.read(btnIdProvider);
  const big = 20;
  const small = 10;
  final smallBlind = MessageEntity(
    type: MessageTypeEnum.game,
    content: GameEntity(
      uid: _assignedIdToUid(smallId, ref),
      type: GameTypeEnum.blind,
      score: small,
    ),
  );
  final bigBlind = MessageEntity(
    type: MessageTypeEnum.game,
    content: GameEntity(
      uid: _assignedIdToUid(bigId, ref),
      type: GameTypeEnum.blind,
      score: big,
    ),
  );
  final btn = MessageEntity(
    type: MessageTypeEnum.game,
    content: GameEntity(
        uid: _assignedIdToUid(btnId, ref), type: GameTypeEnum.btn, score: 0),
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
      .updateStack(_assignedIdToUid(smallId, ref), -small);
  ref
      .read(playerDataProvider.notifier)
      .updateScore(_assignedIdToUid(smallId, ref), small);
  ref
      .read(playerDataProvider.notifier)
      .updateStack(_assignedIdToUid(bigId, ref), -big);
  ref
      .read(playerDataProvider.notifier)
      .updateScore(_assignedIdToUid(bigId, ref), big);
  ref.read(playerDataProvider.notifier).updateBtn(_assignedIdToUid(btnId, ref));
  ref.read(potProvider.notifier).potUpdate(small + big);
}

String _assignedIdToUid(
    int assignedId, AutoDisposeNotifierProviderRef<GameTypeEnum> ref) {
  final players = ref.read(playerDataProvider);
  if (!players.map((e) => e.assignedId).toList().contains(assignedId)) {
    return '';
  }
  return players.firstWhere((e) => e.assignedId == assignedId).uid;
}

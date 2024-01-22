import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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

final flavorProvider =
    Provider((ref) => const String.fromEnvironment('flavor'));

final qrCodeDataProvider = StateProvider<String>((ref) => '');

final idTextFieldControllerProvider = Provider((_) => TextEditingController());

final roomIdProvider =
    StateProvider((ref) => Random().nextInt(99999 - 10000 + 1) + 10000);

final isStartProvider = StateProvider((ref) => false);

final isJoinProvider = StateProvider((ref) => false);

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

final rankingProvider = StateProvider.family((ref, UserEntity _) => 0);

@riverpod
class HostSidePots extends _$HostSidePots {
  @override
  List<SidePotEntity> build() {
    return [];
  }

  void addSidePots(List<SidePotEntity> sidePots) {
    state = [...state, ...sidePots];
  }

  int totalValue() {
    int value = 0;
    for (final pot in state) {
      value += pot.size;
    }
    return value;
  }

  void clear() {
    state = [];
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
        break;
      case GameTypeEnum.ranking:
        break;
    }
  }

  void update(GameTypeEnum gameTypeEnum) {
    state = gameTypeEnum;
  }

  void delayPreFlop() {
    Future.delayed(Duration(seconds: 2), () {
      /// foldを初期化
      ref.read(playerDataProvider.notifier).clearIsFold();

      /// potを初期化
      ref.read(potProvider.notifier).clear();
      ref.read(hostSidePotsProvider.notifier).clear();
      state = GameTypeEnum.preFlop;
    });

    Future.delayed(Duration(seconds: 4), () {
      final cons = ref.read(hostConsProvider);
      _game(cons, ref);
    });
  }
}

///
/// position
///

@Riverpod(keepAlive: true)
class BigId extends _$BigId {
  @override
  int build() {
    return 1;
  }

  void updateId() {
    final players = ref.read(playerDataProvider);
    final len = players.length;
    state = state + 1;
    if (state > len) {
      state = 1;
    }
    while (ref
            .read(playerDataProvider.notifier)
            .curStack(_assignedIdToUid2(state, ref)) ==
        0) {
      state = state + 1;
      if (state > len) {
        state = 1;
      }
    }
  }

  int smallId() {
    final players = ref.read(playerDataProvider);
    int id = state - 1;
    if (id == 0) {
      id = players.length;
    }
    while (ref
            .read(playerDataProvider.notifier)
            .curStack(_assignedIdToUid2(id, ref)) ==
        0) {
      final len = players.length;
      id = id - 1;
      if (id == 0) {
        id = len;
      }
    }
    return id;
  }

  int btnId() {
    final players = ref.read(playerDataProvider);
    final len = players.length;
    if (len == 2) {
      return smallId();
    }
    int id = smallId() - 1;
    if (id == 0) {
      id = len;
    }
    while (ref
            .read(playerDataProvider.notifier)
            .curStack(_assignedIdToUid2(id, ref)) ==
        0) {
      id = id - 1;
      if (id == 0) {
        id = len;
      }
    }
    return id;
  }

  void fixHeads() {
    state = 2;
  }
}

void _game(List<PeerConEntity> cons,
    AutoDisposeNotifierProviderRef<GameTypeEnum> ref) {
  final bigId = ref.read(bigIdProvider);
  final smallId = ref.read(bigIdProvider.notifier).smallId();
  final btnId = ref.read(bigIdProvider.notifier).btnId();
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

String _assignedIdToUid2(int assignedId, NotifierProviderRef<int> ref) {
  final players = ref.read(playerDataProvider);
  print('$assignedId');
  if (!players.map((e) => e.assignedId).toList().contains(assignedId)) {
    return '';
  }
  return players.firstWhere((e) => e.assignedId == assignedId).uid;
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/peer/peer_con_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/domain_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation/opt_id.dart';
import 'package:poker_chip/provider/presentation/peer.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation/pot.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'presentation_providers.g.dart';

final uidProvider = StateProvider<String>((ref) =>
    ref.read(firebaseAuthProvider).currentUser?.uid ?? const Uuid().v4());

final flavorProvider =
    Provider((ref) => const String.fromEnvironment('flavor'));

final idTextFieldControllerProvider = Provider((_) => TextEditingController());

@riverpod
class ErrorText extends _$ErrorText {
  @override
  String build() {
    return '';
  }

  void view() {
    Future.delayed(const Duration(seconds: 2), () {
      final isStart = ref.watch(isJoinProvider);
      if (!isStart) {
        state = '再試行してください';
      }
    });
    Future.delayed(const Duration(seconds: 6), () {
      state = '';
    });
  }
}

final roomIdProvider =
    StateProvider((ref) => Random().nextInt(99999 - 10000 + 1) + 10000);

final isStartProvider = StateProvider((ref) => false);

final isJoinProvider = StateProvider((ref) => false);

final raiseBetProvider = StateProvider((ref) => 0);

final stackProvider = StateProvider((ref) => 1000);

final playersExProvider = StateProvider((ref) => []);

final sbProvider = StateProvider((ref) => 10);

final bbProvider = StateProvider((ref) => 20);

final isSelectedProvider =
    StateProvider.family((ref, UserEntity user) => false);

final rankingProvider = StateProvider.family((ref, UserEntity _) => 1);

///
/// Round
///

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
      case GameTypeEnum.sitOut:
        break;
    }
  }

  void update(GameTypeEnum gameTypeEnum) {
    state = gameTypeEnum;
  }

  void updatePreFlop() {
    /// foldを初期化
    ref.read(playerDataProvider.notifier).clearIsFold();

    /// potを初期化
    ref.read(potProvider.notifier).clear();
    ref.read(hostSidePotsProvider.notifier).clear();

    /// HostのsitOutを更新
    final noneUids = ref.read(playerDataProvider.notifier).stackNoneUids();
    for (final uid in noneUids) {
      ref.read(playerDataProvider.notifier).updateFold(uid);
    }

    /// bigBlindを更新
    ref.read(bigIdProvider.notifier).updateId();

    /// optionIdを更新
    ref.read(optionAssignedIdProvider.notifier).updatePreFlopId();

    /// ParticipantのsitOutを更新
    final cons = ref.read(hostConsProvider);
    for (final con in cons) {
      final conn = con.con;
      for (final uid in noneUids) {
        /// Participantの状態変更
        final game = GameEntity(uid: uid, type: GameTypeEnum.sitOut, score: 0);
        final mes = MessageEntity(type: MessageTypeEnum.game, content: game);
        conn.send(mes.toJson());
      }
    }

    state = GameTypeEnum.preFlop;

    Future.delayed(const Duration(seconds: 2), () {
      final cons = ref.read(hostConsProvider);
      _game(cons, ref);
    });
  }
}

void _game(List<PeerConEntity> cons,
    AutoDisposeNotifierProviderRef<GameTypeEnum> ref) {
  final bigId = ref.read(bigIdProvider);
  final smallId = ref.read(bigIdProvider.notifier).smallId();
  final btnId = ref.read(bigIdProvider.notifier).btnId();
  final big = ref.watch(bbProvider);
  final small = ref.watch(sbProvider);
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
        .read(playerDataProvider)
        .firstWhere((e) => e.uid == _assignedIdToUid2(state, ref))
        .isSitOut) {
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
        .read(playerDataProvider)
        .firstWhere((e) => e.uid == _assignedIdToUid2(state, ref))
        .isSitOut) {
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
        .read(playerDataProvider)
        .firstWhere((e) => e.uid == _assignedIdToUid2(state, ref))
        .isSitOut) {
      id = id - 1;
      if (id == 0) {
        id = len;
      }
    }
    return id;
  }
}

String _assignedIdToUid2(int assignedId, NotifierProviderRef<int> ref) {
  final players = ref.read(playerDataProvider);
  print('$assignedId');
  if (!players.map((e) => e.assignedId).toList().contains(assignedId)) {
    return '';
  }
  return players.firstWhere((e) => e.assignedId == assignedId).uid;
}

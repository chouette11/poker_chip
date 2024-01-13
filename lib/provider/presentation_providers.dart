import 'dart:async';

import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/peer/peer_con_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/domain_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:poker_chip/util/constant/const.dart';
import 'package:uuid/uuid.dart';

part 'presentation_providers.g.dart';

final uidProvider = StateProvider<String>((ref) =>
    ref.read(firebaseAuthProvider).currentUser?.uid ?? const Uuid().v4());

final qrCodeDataProvider = StateProvider<String>((ref) => '');

final raiseBetProvider = StateProvider((ref) => 40);

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

@riverpod
class HostConnOpen extends _$HostConnOpen {
  @override
  bool build(Peer peer) {
    return false;
  }

  void open(BuildContext context) {
    late DataConnection conn;
    peer.on("open").listen((id) {
      print(peer.id);
      print('open!');
    });

    peer.on("close").listen((id) {});

    peer.on<DataConnection>("connection").listen((event) {
      conn = event;
      print('con!');

      conn.on("data").listen((data) {
        print('data!!');
        final mes = MessageEntity.fromJson(data);
        print('host: $mes');
        print(mes.type == MessageTypeEnum.action);

        if (mes.type == MessageTypeEnum.join) {
          UserEntity user = UserEntity.fromJson(mes.content);
          final entity = PeerConEntity(
            uid: user.uid,
            peerId: peer.id ?? '',
            con: event,
          );
          ref.read(hostConsProvider.notifier).add(entity);
          List<UserEntity> players = ref.read(playerDataProvider);
          user = UserEntity(
            uid: user.uid,
            assignedId: players.length + 1,
            name: user.name ?? 'プレイヤー${players.length + 1}',
            stack: user.stack,
            score: 0,
            isBtn: false,
            isAction: false,
            isFold: false,
          );

          /// Hostの状態変更
          ref.read(playerDataProvider.notifier).add(user);

          /// Participantの状態変更
          players = ref.read(playerDataProvider);
          final res =
              MessageEntity(type: MessageTypeEnum.joined, content: players);
          final cons = ref.read(hostConsProvider);
          for (var conEntity in cons) {
            final conn = conEntity.con;
            conn.send(res.toJson());
          }
        } else if (mes.type == MessageTypeEnum.action) {
          ActionEntity action = ActionEntity.fromJson(mes.content);
          final notifier = ref.read(playerDataProvider.notifier);

          /// HostのStack状態変更
          _actionStackMethod(action, ref);

          /// HostのOption状態変更
          print('action');
          final isFoldout = notifier.isFoldout();
          final isChangeRound =
              notifier.isAllAction() && notifier.isSameScore();
          if (isFoldout) {
            final uid = notifier.finalPlayerUid().first;
            final myUid = ref.read(uidProvider);
            ref.read(roundProvider.notifier).update(GameTypeEnum.foldout);
            ref.read(potProvider.notifier).scoreSumToPot();
            ref.read(playerDataProvider.notifier).clearScore();
            final pot = ref.read(potProvider);
            ref.read(playerDataProvider.notifier).updateStack(uid, pot);
            ref.read(playerDataProvider.notifier).clearIsFold();
            ref.read(potProvider.notifier).clear();
            ref.read(smallIdProvider.notifier).updateId();
            ref.read(bigIdProvider.notifier).updateId();
            ref.read(btnIdProvider.notifier).updateId();
            ref.read(optionAssignedIdProvider.notifier).updatePreFlopId();
            ref.read(roundProvider.notifier).delayPreFlop();
            if (uid == myUid) {
              ref.read(isWinProvider.notifier).update((state) => true);
            }
          } else if (isChangeRound) {
            print('change round');
            ref.read(potProvider.notifier).scoreSumToPot();
            ref.read(playerDataProvider.notifier).clearScore();
            ref.read(optionAssignedIdProvider.notifier).updatePostFlopId();
            ref.read(roundProvider.notifier).nextRound();
            ref.read(playerDataProvider.notifier).clearIsAction();
            final round = ref.read(roundProvider);
            if (round == GameTypeEnum.showdown) {
              ref.read(smallIdProvider.notifier).updateId();
              ref.read(bigIdProvider.notifier).updateId();
              ref.read(btnIdProvider.notifier).updateId();
              ref.read(optionAssignedIdProvider.notifier).updatePreFlopId();
            }
          } else {
            ref.read(optionAssignedIdProvider.notifier).updateId();
          }

          /// ParticipantのStack状態変更
          final cons = ref.read(hostConsProvider);
          for (final conEntity in cons) {
            final conn = conEntity.con;
            final optId = ref.read(optionAssignedIdProvider);
            action = action.copyWith.call(optId: optId);
            final mes =
                MessageEntity(type: MessageTypeEnum.action, content: action);
            conn.send(mes.toJson());
          }

          if (isFoldout) {
            /// Participantのターン状態変更
            for (final conEntity in cons) {
              final conn = conEntity.con;
              final ids = notifier.finalPlayerUid();
              final round = ref.read(roundProvider);
              final game = GameEntity(uid: ids.first, type: round, score: 0);
              final mes =
                  MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());

              Future.delayed(const Duration(seconds: 4), () {
                print('timer!');
                final round = ref.read(roundProvider);
                final game = GameEntity(uid: '', type: round, score: 0);
                final mes =
                    MessageEntity(type: MessageTypeEnum.game, content: game);
                conn.send(mes.toJson());
              });
            }
          } else if (isChangeRound) {
            /// Participantのターン状態変更
            for (final conEntity in cons) {
              final conn = conEntity.con;
              final round = ref.read(roundProvider);
              final game = GameEntity(uid: '', type: round, score: 0);
              final mes =
                  MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            }
          }
        } else if (mes.type == MessageTypeEnum.game) {
          GameEntity game = GameEntity.fromJson(mes.content);
          final uid = game.uid;
          final score = game.score;

          if (game.type == GameTypeEnum.showdown) {
            /// HostのStack状態変更
            ref.read(playerDataProvider.notifier).updateStack(uid, score);

            final cons = ref.read(hostConsProvider);
            /// Participantのstack状態変更
            for (final conEntity in cons) {
              final conn = conEntity.con;
              final game = GameEntity(
                  uid: uid, type: GameTypeEnum.showdown, score: score);
              final mes =
                  MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            }
          }

          /// HostのOption状態変更
          ref.read(potProvider.notifier).clear();
          ref.read(playerDataProvider.notifier).clearIsFold();
          ref.read(roundProvider.notifier).delayPreFlop();

          /// ParticipantのOption状態変更
          final cons = ref.read(hostConsProvider);
          for (final conEntity in cons) {
            final conn = conEntity.con;
            Future.delayed(const Duration(seconds: 4), () {
              final round = ref.read(roundProvider);
              final game = GameEntity(uid: '', type: round, score: 0);
              final mes =
              MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            });
          }
        }
      });

      conn.on("binary").listen((data) {});

      conn.on("close").listen((event) {});
      state = true;
    });
  }
}

///
/// Game
///

final isFinalProvider = StateProvider((ref) => false);

final isWinProvider = StateProvider((ref) => false);

final isSelectedProvider =
    StateProvider.family((ref, UserEntity user) => false);

@riverpod
class Pot extends _$Pot {
  @override
  int build() {
    return 0;
  }

  void scoreSumToPot() {
    final player = ref.read(playerDataProvider);
    final scores = player.map((e) => e.score).toList();
    int totalScore = state;
    for (final score in scores) {
      totalScore += score;
    }
    state = totalScore;
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
      case GameTypeEnum.pot:
    }
  }

  void update(GameTypeEnum gameTypeEnum) {
    state = gameTypeEnum;
  }

  void delayPreFlop() {
    print('before');
    Future.delayed(Duration(seconds: 3), () {
      print('after');
      state = GameTypeEnum.preFlop;
    });

    Future.delayed(Duration(seconds: 6), () {
      final cons = ref.read(hostConsProvider);
      _game(cons, ref);
    });
  }
}

final participantOptIdProvider = StateProvider((ref) => 0);

@riverpod
class OptionAssignedId extends _$OptionAssignedId {
  @override
  int build() {
    final len = ref.read(playerDataProvider).length;
    final bigId = ref.read(bigIdProvider);
    if ((bigId + 1) > len) {
      return 1;
    } else {
      return bigId + 1;
    }
  }

  void updateId() {
    final player = List.from(ref.read(playerDataProvider));
    player.removeWhere((e) => e.isFold == true);
    final activeIds = player.map((e) => e.assignedId).toList();
    activeIds.sort();
    int? firstLargerNumber;
    int smallestNumber = activeIds[0];
    for (int id in activeIds) {
      if (id > state) {
        firstLargerNumber = id;
        break;
      }
      if (id < smallestNumber) {
        smallestNumber = id;
      }
    }
    state = firstLargerNumber ?? smallestNumber;
  }

  void updatePreFlopId() {
    final big = ref.read(bigIdProvider);
    final player = List.from(ref.read(playerDataProvider));
    player.removeWhere((e) => e.isFold == true);
    final activeIds = player.map((e) => e.assignedId).toList();
    activeIds.sort();
    int? firstLargerNumber;
    int smallestNumber = activeIds[0];
    for (int id in activeIds) {
      if (id > big) {
        firstLargerNumber = id;
        break;
      }
      if (id < smallestNumber) {
        smallestNumber = id;
      }
    }
    state = firstLargerNumber ?? smallestNumber;
  }

  void updatePostFlopId() {
    final btn = ref.read(btnIdProvider);
    final player = List.from(ref.read(playerDataProvider));
    player.removeWhere((e) => e.isFold == true);
    final activeIds = player.map((e) => e.assignedId).toList();
    activeIds.sort();
    int? firstLargerNumber;
    int smallestNumber = activeIds[0];
    for (int id in activeIds) {
      if (id > btn) {
        firstLargerNumber = id;
        break;
      }
      if (id < smallestNumber) {
        smallestNumber = id;
      }
    }
    state = firstLargerNumber ?? smallestNumber;
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
}

///
/// player
///

@riverpod
class PlayerData extends _$PlayerData {
  @override
  List<UserEntity> build() {
    final uid = ref.read(uidProvider);
    return [
      UserEntity(
        uid: uid,
        stack: 1000,
        assignedId: 1,
        score: 0,
        isBtn: false,
        isAction: false,
        isFold: false,
      )
    ];
  }

  void add(UserEntity user) {
    if (state.where((e) => e.uid == user.uid).isEmpty) {
      state = [...state, user];
    }
  }

  void update(UserEntity user) {
    state = [
      for (final e in state)
        if (e.uid == user.uid) user else e,
    ];
  }

  void updateStack(String uid, int? score) {
    state = [
      for (final user in state)
        if (user.uid == uid)
          user.copyWith(stack: user.stack + (score ?? 0))
        else
          user,
    ];
  }

  void updateScore(String uid, int score) {
    state = [
      for (final user in state)
        if (user.uid == uid) user.copyWith(score: score) else user,
    ];
  }

  void updateBtn(String uid) {
    state = [
      for (final user in state)
        if (user.uid == uid)
          user.copyWith(isBtn: true)
        else
          user.copyWith(isBtn: false),
    ];
  }

  void updateAction(String uid) {
    state = [
      for (final user in state)
        if (user.uid == uid) user.copyWith(isAction: true) else user
    ];
  }

  void updateFold(String uid) {
    state = [
      for (final user in state)
        if (user.uid == uid) user.copyWith(isFold: true) else user
    ];
  }

  void clearScore() {
    state = [
      for (final user in state) user.copyWith(score: 0),
    ];
  }

  void clearIsAction() {
    state = [
      for (final user in state) user.copyWith(isAction: false),
    ];
  }

  void clearIsFold() {
    state = [
      for (final user in state) user.copyWith(isFold: false),
    ];
  }

  bool isAllAction() {
    final players = List.from(state);
    players.removeWhere((e) => e.isFold == true);
    final values = players.map((e) => e.isAction).toList();
    return !values.contains(false);
  }

  bool isSameScore() {
    final player = List.from(state);
    player.removeWhere((e) => e.isFold == true);
    final values = player.map((e) => e.score).toList();
    if (values.isEmpty) return true;

    final first = values.first;
    for (final value in values) {
      if (value != first) {
        return false;
      }
    }
    return true;
  }

  bool isFoldout() {
    final player = List.from(state);
    player.removeWhere((e) => e.isFold == true);
    return player.length == 1;
  }

  List<String> finalPlayerUid() {
    List<UserEntity> player = List.from(state);
    player.removeWhere((e) => e.isFold == true);
    return player.map((e) => e.uid).toList();
  }

  String finalUidString() {
    List<UserEntity> player = List.from(state);
    player.removeWhere((e) => e.isFold == true);
    final uids = player.map((e) => e.uid).toList();
    String value = '';
    for (final uid in uids) {
      value += '$uid ';
    }
    return value;
  }
}

void _actionStackMethod(
    ActionEntity action, AutoDisposeNotifierProviderRef<bool> ref) {
  /// Hostの状態変更
  final type = action.type;
  final uid = action.uid;
  final score = action.score;
  ref.read(playerDataProvider.notifier).updateAction(uid);
  switch (type) {
    case ActionTypeEnum.fold:
      ref.read(playerDataProvider.notifier).updateFold(uid);
      break;
    case ActionTypeEnum.call:
      ref.read(playerDataProvider.notifier).updateStack(uid, -score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      break;
    case ActionTypeEnum.raise:
      ref.read(playerDataProvider.notifier).updateStack(uid, -score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      break;
    case ActionTypeEnum.bet:
      ref.read(playerDataProvider.notifier).updateStack(uid, -score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      break;
    case ActionTypeEnum.check:
      break;
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
  ref
      .read(playerDataProvider.notifier)
      .updateStack(_assignedIdToUid(btnId, ref), 0);
  ref
      .read(playerDataProvider.notifier)
      .updateScore(_assignedIdToUid(btnId, ref), 0);
}

String _assignedIdToUid(
    int assignedId, AutoDisposeNotifierProviderRef<GameTypeEnum> ref) {
  final players = ref.read(playerDataProvider);
  if (!players.map((e) => e.assignedId).toList().contains(assignedId)) {
    return '';
  }
  return players.firstWhere((e) => e.assignedId == assignedId).uid;
}

final messageTextFieldController = Provider((_) => TextEditingController());

final tutorialTextFieldController = Provider((_) => TextEditingController());

final idTextFieldProvider = StateProvider<String>((ref) => '');

final errorTextProvider = StateProvider((ref) => '');

@riverpod
class LimitTime extends _$LimitTime {
  @override
  int build() {
    const flavor = String.fromEnvironment('flavor');
    if (flavor == 'tes') {
      return 10;
    }
    return 100;
  }

  void reset() {
    state = 100;
    const flavor = String.fromEnvironment('flavor');
    if (flavor == 'tes') {
      state = 10;
    }
  }

  void startTimer(DateTime startTime) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      const flavor = String.fromEnvironment('flavor');
      final time = DateTime.now().difference(startTime);
      final value = 100 + ROLE_DIALOG_TIME + 3 - time.inSeconds;
      state = flavor == 'tes' ? state - 1 : (value > 100 ? 100 : value);
      if (state < 1) {
        timer.cancel();
      }
    });
  }
}

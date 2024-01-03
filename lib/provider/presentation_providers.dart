import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/page/game/component/qr_dialog.dart';
import 'package:poker_chip/page/game/paticipant_page.dart';
import 'package:poker_chip/provider/domain_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/host.dart';
import 'package:poker_chip/util/enum/participant.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:poker_chip/util/constant/const.dart';
import 'package:uuid/uuid.dart';

part 'presentation_providers.g.dart';

final messageTextFieldController = Provider((_) => TextEditingController());

final tutorialTextFieldController = Provider((_) => TextEditingController());

final idTextFieldProvider = StateProvider<String>((ref) => '');

final uidProvider = StateProvider<String>((ref) =>
    ref.read(firebaseAuthProvider).currentUser?.uid ?? const Uuid().v4());

final errorTextProvider = StateProvider((ref) => '');

final qrCodeDataProvider = StateProvider<String>((ref) => '');

final scoreProvider = StateProvider((ref) => 0);

final conProvider =
    StateProvider.family((ref, String id) => Peer().connect(id));

final peerProvider =
    Provider((ref) => Peer(id: 'c78da73a-9b97-4efc-9303-4161de32b84f'));

@riverpod
class IsConn extends _$IsConn {
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
      ref.read(conProvider('').notifier).update((state) => event);

      conn.on("data").listen((data) {
        print('data!!');
        final json = data as String;
        final mes = MessageEntity.fromJson(jsonDecode(json));
        print('host: $mes');
        if (mes.type == ParticipantMessageTypeEnum.join.name) {
          UserEntity user = UserEntity.fromJson(mes.content);
          final players = ref.read(playerDataProvider);
          user = UserEntity(
              uid: user.uid,
              assignedId: players.length + 1,
              name: user.name ?? 'プレイヤー${players.length + 1}',
              stack: user.stack,
              isBtn: false);
          ref.read(playerDataProvider.notifier).add(user);
          final res = MessageEntity(
              type: HostMessageTypeEnum.joined.name, content: user);
          conn.send(res.toJson());

          final uid = ref.read(uidProvider);
          conn.send(MessageEntity(
            type: HostMessageTypeEnum.joined.name,
            content: UserEntity(
                uid: uid,
                assignedId: 1,
                name: 'プレイヤー1',
                stack: 1000,
                isBtn: false),
          ).toJson());
        } else if (mes.type == ParticipantMessageTypeEnum.action.name) {
          final action = ActionEntity.fromJson(mes.content);
          _actionMethod(action, ref);
        }
      });

      conn.on("binary").listen((data) {});

      conn.on("close").listen((event) {});
      state = true;
    });
  }
}

@riverpod
class BtnId extends _$BtnId {
  @override
  int build() {
    return 1;
  }

  void fixId(int assignedId) {
    final len = ref.read(playerDataProvider).length;
    if ((state + 1) > len) {
      state = 1;
    } else {
      state = state + 1;
    }
  }
}

@riverpod
class SmallId extends _$SmallId {
  @override
  int build() {
    final btnId = ref.read(btnIdProvider);
    final len = ref.read(playerDataProvider).length;
    if ((btnId + 1) > len) {
      return 1;
    } else {
      return btnId + 1;
    }
  }

  void fixId(int assignedId) {
    final len = ref.read(playerDataProvider).length;
    if ((state + 1) > len) {
      state = 1;
    } else {
      state = state + 1;
    }
  }
}

@riverpod
class BigId extends _$BigId {
  @override
  int build() {
    final smallId = ref.read(smallIdProvider);
    final len = ref.read(playerDataProvider).length;
    if ((smallId + 1) > len) {
      return 1;
    } else {
      return smallId + 1;
    }
  }

  void fixId(int assignedId) {
    final len = ref.read(playerDataProvider).length;
    if ((state + 1) > len) {
      state = 1;
    } else {
      state = state + 1;
    }
  }
}

@riverpod
class PlayerData extends _$PlayerData {
  @override
  List<UserEntity> build() {
    final uid = ref.read(uidProvider);
    return [UserEntity(uid: uid, stack: 1000, assignedId: 1, isBtn: false)];
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

  void updateScore(String uid, int? score) {
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
}

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

void _actionMethod(
    ActionEntity action, AutoDisposeNotifierProviderRef<bool> ref) {
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

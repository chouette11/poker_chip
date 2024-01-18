import 'dart:async';

import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/peer/peer_con_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:poker_chip/provider/presentation/opt_id.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'host_conn_open.g.dart';

@Riverpod(keepAlive: true)
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
            final winner = notifier.activePlayers().first;
            ref.read(roundProvider.notifier).update(GameTypeEnum.foldout);
            ref.read(playerDataProvider.notifier).clearScore();
            final pot = ref.read(potProvider);
            ref.read(playerDataProvider.notifier).updateStack(winner.uid, pot);
            ref.read(smallIdProvider.notifier).updateId();
            ref.read(bigIdProvider.notifier).updateId();
            ref.read(btnIdProvider.notifier).updateId();
            ref.read(optionAssignedIdProvider.notifier).updatePreFlopId();
            ref.read(roundProvider.notifier).delayPreFlop();
          } else if (isChangeRound) {
            print('change round');
            if (notifier.isStackNone()) {
              final sidePots =
              ref.read(playerDataProvider.notifier).calculateSidePots();
              ref.read(hostSidePotsProvider.notifier).addSidePots(sidePots);

              final cons = ref.read(hostConsProvider);
              for (final con in cons) {
                final conn = con.con;
                for (final sidePot in sidePots) {
                  /// Hostの状態変更
                  ref.read(sidePotsProvider.notifier).addSidePot(sidePot.size);

                  /// Participantの状態変更
                  final game = GameEntity(
                      uid: '', type: GameTypeEnum.sidePot, score: sidePot.size);
                  final mes =
                  MessageEntity(type: MessageTypeEnum.game, content: game);
                  conn.send(mes.toJson());
                }
              }
            }
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
              final uids = notifier.activePlayers().map((e) => e.uid).toList();
              final round = ref.read(roundProvider);
              final pot = ref.read(potProvider);
              final game = GameEntity(uid: uids.first, type: round, score: pot);
              final mes =
              MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());

              Future.delayed(const Duration(seconds: 4), () {
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

void _actionStackMethod(ActionEntity action, NotifierProviderRef<bool> ref) {
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
      final curScore = ref.read(playerDataProvider.notifier).curScore(uid);
      final fixScore = score - curScore;
      ref.read(playerDataProvider.notifier).updateStack(uid, -fixScore);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      ref.read(potProvider.notifier).potUpdate(fixScore);
      break;
    case ActionTypeEnum.raise:
      ref.read(playerDataProvider.notifier).updateStack(uid, -score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      ref.read(potProvider.notifier).potUpdate(score);
      break;
    case ActionTypeEnum.bet:
      ref.read(playerDataProvider.notifier).updateStack(uid, -score);
      ref.read(playerDataProvider.notifier).updateScore(uid, score);
      ref.read(potProvider.notifier).potUpdate(score);
      break;
    case ActionTypeEnum.check:
      break;
  }
}
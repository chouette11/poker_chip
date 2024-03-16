import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/model/entity/action/action_entity.dart';
import 'package:poker_chip/model/entity/game/game_entity.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:poker_chip/page/game/host/component/host_ranking_button.dart';
import 'package:poker_chip/provider/presentation/opt_id.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation/pot.dart';
import 'package:poker_chip/provider/presentation/round.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/context_extension.dart';
import 'package:poker_chip/util/enum/action.dart';
import 'package:poker_chip/util/enum/game.dart';
import 'package:poker_chip/util/enum/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'peer.g.dart';

final peerProvider = ProviderFamily((ref, String id) => Peer(id: id));

final participantConProvider = StateProvider<DataConnection?>((ref) => null);

@riverpod
class HostCons extends _$HostCons {
  @override
  List<DataConnection> build() {
    return [];
  }

  void add(DataConnection conn) {
    if (state.map((e) => e.label).toList().contains(conn.label)) {
      return;
    }
    state = [...state, conn];
  }

  void send(MessageEntity mes) {
    for (final conn in state) {
      conn.send(mes.toJson());
    }
  }
}

final hostResCountProvider = StateProvider((ref) => 0);

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
      ref.read(hostConsProvider.notifier).add(event);

      conn.on("data").listen((data) {
        print('data!!');
        final mes = MessageEntity.fromJson(data);
        print('host: $mes');

        if (mes.type == MessageTypeEnum.join) {
          UserEntity user = UserEntity.fromJson(mes.content);
          ref.read(hostConsProvider.notifier).add(event);

          final uids = ref.read(playerDataProvider).map((e) => e.uid).toList();
          if (uids.contains(user.uid)) {
            /// Hostの状態変更
            user = ref
                .read(playerDataProvider.notifier)
                .specificPlayer(user.uid)
                .copyWith
                .call(isAction: true, isFold: true, isSitOut: true);
            ref.read(playerDataProvider.notifier).update(user);

            /// Participantの状態変更
            final players = ref.read(playerDataProvider);
            final res =
                MessageEntity(type: MessageTypeEnum.joined, content: players);
            ref.read(hostConsProvider.notifier).send(res);

            _killAction(ref);
          } else {
            List<UserEntity> players = ref.read(playerDataProvider);
            final isStart = ref.read(isStartProvider);
            user = UserEntity(
              uid: user.uid,
              assignedId: players.length + 1,
              name: user.name ?? context.l10n.playerX(players.length + 1),
              stack: ref.watch(stackProvider),
              score: 0,
              isBtn: false,
              isAction: false,
              isFold: false,
              isCheck: false,
              isSitOut: isStart,
            );

            /// Hostの状態変更
            ref.read(playerDataProvider.notifier).add(user);

            /// Participantの状態変更
            players = ref.read(playerDataProvider);
            final res =
                MessageEntity(type: MessageTypeEnum.joined, content: players);
            ref.read(hostConsProvider.notifier).send(res);
          }
        } else if (mes.type == MessageTypeEnum.sit) {
          final uid = mes.content as String;
          ref.read(sittingUidsProvider.notifier).add(uid);
          // ゲームが終了していた場合即時参加
          if (!ref.read(isStartProvider)) {
            ref.read(playerDataProvider.notifier).updateSitOut(uid, false);
          }
        } else if (mes.type == MessageTypeEnum.userSetting) {
          UserEntity user = UserEntity.fromJson(mes.content);
          final notifier = ref.read(playerDataProvider.notifier);

          /// Hostの状態変更
          notifier.update(user);

          /// Participantの状態変更
          final res = MessageEntity(
            type: MessageTypeEnum.userSetting,
            content: user,
          );
          ref.read(hostConsProvider.notifier).send(res);
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
          final isAllinShowDown = notifier.isAllinShowDown();
          if (isFoldout) {
            final winner = notifier.activePlayers().first;
            ref.read(roundProvider.notifier).update(GameTypeEnum.foldout);
            ref.read(playerDataProvider.notifier).clearScore();
            ref.read(playerDataProvider.notifier).clearIsAction();
            ref.read(playerDataProvider.notifier).clearIsCheck();
            final pot = ref.read(potProvider);
            ref.read(playerDataProvider.notifier).updateStack(winner.uid, pot);
            final cons = ref.read(hostConsProvider);

            /// Participantのターン状態変更
            for (final conn in cons) {
              final uids = notifier.activePlayers().map((e) => e.uid).toList();
              final game = GameEntity(
                  uid: uids.first, type: GameTypeEnum.foldout, score: pot);
              final mes =
                  MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            }
            ref.read(roundProvider.notifier).updatePreFlop();
          } else if (isAllinShowDown) {
            if (notifier.isStackNone()) {
              final sidePots =
                  ref.read(playerDataProvider.notifier).calculateSidePots();
              ref.read(hostSidePotsProvider.notifier).addSidePots(sidePots);

              final cons = ref.read(hostConsProvider);
              for (final conn in cons) {
                for (final sidePot in sidePots) {
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
            ref.read(roundProvider.notifier).update(GameTypeEnum.showdown);
            ref.read(playerDataProvider.notifier).clearIsAction();
            ref.read(playerDataProvider.notifier).clearIsCheck();
          } else if (isChangeRound) {
            print('change round');
            if (notifier.isStackNone()) {
              final sidePots =
                  ref.read(playerDataProvider.notifier).calculateSidePots();
              ref.read(hostSidePotsProvider.notifier).addSidePots(sidePots);

              final cons = ref.read(hostConsProvider);
              for (final conn in cons) {
                for (final sidePot in sidePots) {
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
            ref.read(playerDataProvider.notifier).clearIsCheck();
          } else {
            ref.read(optionAssignedIdProvider.notifier).updateId();
          }

          /// ParticipantのStack状態変更
          final cons = ref.read(hostConsProvider);
          for (final conn in cons) {
            final optId = ref.read(optionAssignedIdProvider);
            action = action.copyWith.call(optId: optId);
            final mes =
                MessageEntity(type: MessageTypeEnum.action, content: action);
            conn.send(mes.toJson());
          }

          if (isFoldout) {
            /// Participantのターン状態変更
            for (final conn in cons) {
              final optId = ref.read(optionAssignedIdProvider);
              final game =
                  GameEntity(uid: '', type: GameTypeEnum.preFlop, score: optId);
              final mes =
                  MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            }
          } else if (isChangeRound || isAllinShowDown) {
            /// Participantのターン状態変更
            for (final conn in cons) {
              final round = ref.read(roundProvider);
              final game = GameEntity(uid: '', type: round, score: 0);
              final mes =
                  MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            }
          }
        } else if (mes.type == MessageTypeEnum.game) {
          GameEntity game = GameEntity.fromJson(mes.content);
          print(game);
          final uid = game.uid;
          final score = game.score;

          if (game.type == GameTypeEnum.showdown) {
            /// HostのStack状態変更
            ref.read(playerDataProvider.notifier).updateStack(uid, score);

            final cons = ref.read(hostConsProvider);

            /// Participantのstack状態変更
            for (final conn in cons) {
              final game = GameEntity(
                  uid: uid, type: GameTypeEnum.showdown, score: score);
              final mes =
                  MessageEntity(type: MessageTypeEnum.game, content: game);
              conn.send(mes.toJson());
            }
          } else if (game.type == GameTypeEnum.ranking) {
            final rankingMap = jsonDecode(game.uid);
            final sidePots = ref.read(hostSidePotsProvider);
            final curPotSize = ref.read(potProvider.notifier).currentSize(true);
            final finalUids =
                ref.read(hostSidePotsProvider.notifier).finalistUids();
            final distributionMap =
                distributeSidePots(sidePots, curPotSize, finalUids, rankingMap);
            final uids = distributionMap.keys.toList();
            final cons = ref.read(hostConsProvider);
            for (final uid in uids) {
              final score = distributionMap[uid] ?? 0;

              /// HostのStack状態変更
              ref.read(playerDataProvider.notifier).updateStack(uid, score);

              /// Participantのstack状態変更
              for (final conn in cons) {
                final game = GameEntity(
                    uid: uid, type: GameTypeEnum.showdown, score: score);
                final mes =
                    MessageEntity(type: MessageTypeEnum.game, content: game);
                conn.send(mes.toJson());
              }
            }
          }

          /// HostのOption状態変更
          ref.read(roundProvider.notifier).updatePreFlop();

          /// ParticipantのOption状態変更
          final optId = ref.read(optionAssignedIdProvider);
          final cons = ref.read(hostConsProvider);
          for (final conn in cons) {
            final game =
                GameEntity(uid: '', type: GameTypeEnum.preFlop, score: optId);
            final mes =
                MessageEntity(type: MessageTypeEnum.game, content: game);
            conn.send(mes.toJson());
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
      ref.read(playerDataProvider.notifier).updateCheck(uid);
      break;
  }
}

void _killAction(Ref ref) {
  final notifier = ref.read(playerDataProvider.notifier);
  final cons = ref.read(hostConsProvider);
  /// HostのOption状態変更
  final isFoldout = notifier.isFoldout();
  final isChangeRound = notifier.isAllAction() && notifier.isSameScore();
  final isAllinShowDown = notifier.isAllinShowDown();
  if (isFoldout) {
    final winner = notifier.activePlayers().first;
    ref.read(roundProvider.notifier).update(GameTypeEnum.foldout);
    ref.read(playerDataProvider.notifier).clearScore();
    ref.read(playerDataProvider.notifier).clearIsAction();
    ref.read(playerDataProvider.notifier).clearIsCheck();
    final pot = ref.read(potProvider);
    ref.read(playerDataProvider.notifier).updateStack(winner.uid, pot);

    /// Participantのターン状態変更
    for (final conn in cons) {
      final uids = notifier.activePlayers().map((e) => e.uid).toList();
      final game = GameEntity(
          uid: uids.first, type: GameTypeEnum.foldout, score: pot);
      final mes =
      MessageEntity(type: MessageTypeEnum.game, content: game);
      conn.send(mes.toJson());
    }

    ref.read(roundProvider.notifier).updatePreFlop();
  } else if (isAllinShowDown) {
    if (notifier.isStackNone()) {
      final sidePots =
      ref.read(playerDataProvider.notifier).calculateSidePots();
      ref.read(hostSidePotsProvider.notifier).addSidePots(sidePots);

      final cons = ref.read(hostConsProvider);
      for (final conn in cons) {
        for (final sidePot in sidePots) {
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
    ref.read(roundProvider.notifier).update(GameTypeEnum.showdown);
    ref.read(playerDataProvider.notifier).clearIsAction();
    ref.read(playerDataProvider.notifier).clearIsCheck();
  } else if (isChangeRound) {
    if (notifier.isStackNone()) {
      final sidePots =
      ref.read(playerDataProvider.notifier).calculateSidePots();
      ref.read(hostSidePotsProvider.notifier).addSidePots(sidePots);

      final cons = ref.read(hostConsProvider);
      for (final conn in cons) {
        for (final sidePot in sidePots) {
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
    ref.read(playerDataProvider.notifier).clearIsCheck();
  } else {
    ref.read(optionAssignedIdProvider.notifier).updateId();
  }

  if (isFoldout) {
    /// Participantのターン状態変更
    for (final conn in cons) {
      final optId = ref.read(optionAssignedIdProvider);
      final game =
      GameEntity(uid: '', type: GameTypeEnum.preFlop, score: optId);
      final mes =
      MessageEntity(type: MessageTypeEnum.game, content: game);
      conn.send(mes.toJson());
    }
  } else if (isChangeRound || isAllinShowDown) {
    /// Participantのターン状態変更
    for (final conn in cons) {
      final round = ref.read(roundProvider);
      final game = GameEntity(uid: '', type: round, score: 0);
      final mes =
      MessageEntity(type: MessageTypeEnum.game, content: game);
      conn.send(mes.toJson());
    }
  }
}
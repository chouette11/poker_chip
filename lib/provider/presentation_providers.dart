import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/domain_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'presentation_providers.g.dart';

final uidProvider = StateProvider<String>((ref) =>
    ref.read(firebaseAuthProvider).currentUser?.uid ?? const Uuid().v4());

final flavorProvider =
    Provider((ref) => const String.fromEnvironment('flavor'));

final idTextFieldControllerProvider = Provider((_) => TextEditingController());

final isSittingButtonProvider = StateProvider((ref) => true);

final nameProvider = StateProvider<String?>((ref) => null);

@Riverpod(keepAlive: true)
class SittingUids extends _$SittingUids {
  @override
  List<String> build() {
    return [];
  }

  void add(String uid) {
    if (state.where((e) => e == uid).isEmpty) {
      state = [...state, uid];
    }
  }

  void clear() {
    state = [];
  }
}

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

final isReviewDialogProvider = StateProvider((ref) => false);

final raiseBetProvider = StateProvider((ref) => 0);

final stackProvider = StateProvider((ref) => 1000);

final sbProvider = StateProvider((ref) => 10);

final bbProvider = StateProvider((ref) => 20);

final playersExProvider = StateProvider((ref) => []);

final isSelectedProvider =
    StateProvider.family((ref, UserEntity user) => false);

final rankingProvider = StateProvider.family((ref, UserEntity _) => 1);

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
        .firstWhere((e) => e.uid == _assignedIdToUid2(id, ref))
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
    if (ref.read(playerDataProvider.notifier).activePlayers().length == 2) {
      return smallId();
    }
    int id = smallId() - 1;
    if (id == 0) {
      id = len;
    }
    while (ref
        .read(playerDataProvider)
        .firstWhere((e) => e.uid == _assignedIdToUid2(id, ref))
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

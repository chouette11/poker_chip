import 'package:poker_chip/model/entity/side_pot/side_pot_entity.dart';
import 'package:poker_chip/model/entity/user/user_entity.dart';
import 'package:poker_chip/provider/presentation/pot.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player.g.dart';

@riverpod
class PlayerData extends _$PlayerData {
  @override
  List<UserEntity> build() {
    final uid = ref.read(uidProvider);
    return [
      UserEntity(
        uid: uid,
        stack: ref.read(stackProvider),
        assignedId: 1,
        score: 0,
        isBtn: false,
        isAction: false,
        isFold: false,
        isCheck: false,
        isSitOut: false,
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

  void updateCheck(String uid) {
    state = [
      for (final user in state)
        if (user.uid == uid) user.copyWith(isCheck: true) else user
    ];
  }

  void updateSitOut(String uid) {
    state = [
      for (final user in state)
        if (user.uid == uid) user.copyWith(isSitOut: true) else user
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

  void clearIsCheck() {
    state = [
      for (final user in state) user.copyWith(isCheck: false),
    ];
  }

  int totalScore() {
    int total = 0;
    for (final user in state) {
      total += user.score;
    }
    return total;
  }

  bool isAllAction() {
    final List<UserEntity> players = List.from(state);
    players.removeWhere((e) => e.isFold == true);
    players.removeWhere((e) => e.stack == 0);
    final values = players.map((e) => e.isAction).toList();
    return !values.contains(false);
  }

  bool isSameScore() {
    final List<UserEntity> player = List.from(state);
    player.removeWhere((e) => e.isFold == true);
    player.removeWhere((e) => e.stack == 0 && e.score == 0);
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

  bool isAllinShowDown() {
    final List<UserEntity> players = List.from(state);
    players.removeWhere((e) => e.isFold == true);
    players.removeWhere((e) => e.stack == 0);
    return players.length == 1;
  }

  bool isStackNone() {
    final List<UserEntity> players = List.from(state);
    players.removeWhere((e) => e.isFold == true);
    final result = players.indexWhere((e) => e.stack == 0 && e.score != 0);
    return result != -1;
  }

  List<String> stackNoneUids() {
    final List<UserEntity> player = List.from(state);
    player.removeWhere((e) => e.isFold == true);
    player.removeWhere((e) => e.stack != 0);
    return player.map((e) => e.uid).toList();
  }

  List<UserEntity> activePlayers() {
    List<UserEntity> player = List.from(state);
    player.removeWhere((e) => e.isFold == true);
    player.removeWhere((e) => e.isSitOut == true);
    return player;
  }

  List<SidePotEntity> calculateSidePots() {
    List<UserEntity> users = List.from(state);

    // allin userが前のラウンドと変わっていない場合サイドポットを作成しない
    final noneUids = stackNoneUids();
    final prevSidePots = ref.read(hostSidePotsProvider);
    if (prevSidePots.isNotEmpty) {
      final lastSidePot = prevSidePots[prevSidePots.length - 1];
      if (!_hasUniqueElements(lastSidePot.allinUids, noneUids)) {
        return [];
      }
    }

    final pot = ref.read(potProvider);
    int count = 0;
    final prevPot = pot -
        ref.read(hostSidePotsProvider.notifier).totalValue() -
        ref.read(playerDataProvider.notifier).totalScore();

    print(prevPot);

    // ユーザーをベット額の昇順にソート
    users.sort((a, b) => a.score.compareTo(b.score));

    List<SidePotEntity> sidePots = [];
    int previousScore = 0;

    for (var i = 0; i < users.length; i++) {
      int contribution = users[i].score - previousScore;

      // 各ユーザーが作るサイドポットの計算
      if (contribution > 0) {
        int sidePotValue = 0;
        List<String> involvedUsers = [];

        for (var j = i; j < users.length; j++) {
          sidePotValue += contribution; // 各ユーザーの寄与額を加算
          involvedUsers.add(users[j].uid);
        }

        if (count == 0) {
          sidePotValue += prevPot;
        }

        final sidePot = SidePotEntity(
            uids: involvedUsers, size: sidePotValue, allinUids: noneUids);
        sidePots.add(sidePot);
        print(sidePot);
        count++;

        previousScore = users[i].score;
      }
    }

    return sidePots;
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

  int curScore(String uid) {
    final player = state.firstWhere((e) => e.uid == uid);
    return player.score;
  }

  int curStack(String uid) {
    final player = state.firstWhere((e) => e.uid == uid);
    return player.stack;
  }
}

bool _hasUniqueElements(List<String> a, List<String> b) {
  // Aの要素を簡単に検索できるようにSetに変換
  var setA = a.toSet();

  // Bの各要素に対して、それがAに含まれていないかどうかをチェック
  for (var element in b) {
    if (!setA.contains(element)) {
      return true; // Aに含まれていない要素が見つかった
    }
  }
  return false; // すべてのBの要素がAに含まれている
}
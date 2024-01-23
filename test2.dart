class UserEntity {
  String uid;
  int score;  // ユーザーがベットしたチップ数

  UserEntity(this.uid, this.score);
}

class SidePot {
  int size;  // サイドポットのサイズ
  List<String> users;  // サイドポットに関与するユーザーのリスト

  SidePot(this.size, this.users);
}

Map<String, int> distributeSidePots(List<SidePot> sidePots, Map<String, int> userRankings) {
  // 各ユーザーに分配されるチップの量を記録するマップ
  Map<String, int> distributions = {};

  // ランキング順にソートされたユーザーIDのリストを作成
  var sortedUsers = userRankings.keys.toList();
  sortedUsers.sort((a, b) => userRankings[a]!.compareTo(userRankings[b]!));

  // 各サイドポットに対して
  for (var pot in sidePots) {
    // このポットを獲得できる最高ランクを見つける
    List<String> eligibleWinners = [];
    for (var uid in sortedUsers) {
      if (pot.users.contains(uid)) {
        if (eligibleWinners.isEmpty || userRankings[uid] == userRankings[eligibleWinners[0]]) {
          eligibleWinners.add(uid);
        } else {
          break;
        }
      }
    }

    // サイドポットを関連する勝者に分配
    int potShare = pot.size ~/ eligibleWinners.length;
    for (var winner in eligibleWinners) {
      distributions.update(winner, (value) => value + potShare, ifAbsent: () => potShare);
    }
  }

  return distributions;
}

void main() {
  // サイドポットとユーザーランキングの例
  var sidePots = [
    SidePot(200, ['uid2', 'uid3', 'uid1', 'uid4']),
    SidePot(100, ['uid3', 'uid1', 'uid4']),
    SidePot(50, ['uid1', 'uid4']),
    SidePot(100, ['uid4'])
  ];

  var userRankings = {
    'uid3': 1,
    'uid2': 2,  // uid1とuid4が1位で引き分け
    'uid1': 3,  // 2位
    'uid4': 4   // 3位
  };

  var distributions = distributeSidePots(sidePots, userRankings);
  print(distributions);
}

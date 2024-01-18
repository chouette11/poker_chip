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

Map<String, int> distributeSidePots(List<SidePot> sidePots, List<List<String>> rankings) {
  // 各ユーザーに分配されるチップの量を記録するマップ
  Map<String, int> distributions = {};

  // 各サイドポットに対して
  for (var pot in sidePots) {
    // このポットを獲得できる最高ランクを見つける
    List<String> eligibleWinners = [];
    for (var rank in rankings) {
      eligibleWinners = rank.where((uid) => pot.users.contains(uid)).toList();
      if (eligibleWinners.isNotEmpty) {
        break;
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
  // サイドポットとランキングの例
  var sidePots = [
    SidePot(200, ['uid2', 'uid3', 'uid1', 'uid4']),
    SidePot(80, ['uid3', 'uid1', 'uid4']),
    SidePot(50, ['uid1', 'uid4']),
    SidePot(100, ['uid4'])
  ];

  var rankings = [
    ['uid3'],
    ['uid1', 'uid4'],  // 1位（引き分け）
             // 2位
    ['uid2']           // 3位
  ];

  var distributions = distributeSidePots(sidePots, rankings);
  print(distributions);
}

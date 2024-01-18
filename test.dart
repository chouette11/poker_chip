class UserEntity {
  String uid;
  int score; // このユーザーがベットしたチップ数

  UserEntity(this.uid, this.score);
}

List<Map<String, dynamic>> calculateSidePots(List<UserEntity> users) {
  // ユーザーをベット額の昇順にソート
  users.sort((a, b) => a.score.compareTo(b.score));

  List<Map<String, dynamic>> sidePots = [];
  int previousScore = 0;

  for (var i = 0; i < users.length; i++) {
    int contribution = users[i].score - previousScore;

    // 各ユーザーが作るサイドポットの計算
    if (contribution > 0) {
      int sidePot = 0;
      List<String> involvedUsers = [];

      for (var j = i; j < users.length; j++) {
        sidePot += contribution; // 各ユーザーの寄与額を加算
        involvedUsers.add(users[j].uid);
      }

      sidePots.add({
        'size': sidePot,
        'users': involvedUsers
      });

      previousScore = users[i].score;
    }
  }

  return sidePots;
}

void main() {
  // 例: ユーザーリストの作成
  var users = [
    UserEntity("uid1", 100),
    UserEntity("uid2", 100),
    UserEntity("uid3", 100),
    UserEntity("uid4", 100),
  ];

  // サイドポットの計算
  var sidePots = calculateSidePots(users);
  print(sidePots);
}

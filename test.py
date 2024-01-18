class UserEntity:
    def __init__(self, uid, score):
        self.uid = uid
        self.score = score

def create_side_pots(players):
    # プレイヤーをスコアでソート
    sorted_players = sorted(players, key=lambda x: x.score)

    side_pots = []
    previous_score = 0

    for i, player in enumerate(sorted_players):
        if player.score > previous_score:
            # サイドポットの計算
            pot_size = (player.score - previous_score) * (len(sorted_players) - i)
            side_pots.append({'size': pot_size, 'uids': [p.uid for p in sorted_players[i:]]})
            previous_score = player.score

    return side_pots

# 例
players = [UserEntity(1, 100), UserEntity(2, 200), UserEntity(3, 50), UserEntity(4, 200)]
print(create_side_pots(players))

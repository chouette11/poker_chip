def move_to_front(arr, target):
    if target in arr:
        # targetの位置を見つける
        target_index = arr.index(target)

        # targetを配列の最初に移動する
        # arr[target_index:] + arr[:target_index] で配列を回転させる
        arr = arr[target_index:] + arr[:target_index]

    return arr

# 使用例
arr = [1, 2, 3, 4]
target = 3
print(move_to_front(arr, target))

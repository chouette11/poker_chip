List<int> rotateToMiddle(List<int> arr, int target) {
  int index = arr.indexOf(target);
  if (index != -1) {
    int midIndex = arr.length ~/ 2; // 中央のインデックス
    int shift = index - midIndex; // 必要なシフト量

    if (shift > 0) {
      // targetを中央に移動するために右にシフト
      return arr.sublist(shift) + arr.sublist(0, shift);
    } else if (shift < 0) {
      // targetを中央に移動するために左にシフト
      return arr.sublist(arr.length + shift) + arr.sublist(0, arr.length + shift);
    }
  }
  return arr;
}

void splitArrayAroundTarget(List<int> arr, int target) {
  int index = arr.indexOf(target);

  if (index != -1) {
    // targetの前までの要素を含む配列
    List<int> beforeTarget = arr.sublist(0, index);

    // targetの後の要素を含む配列
    List<int> afterTarget = arr.sublist(index + 1);

    print("Before Target: $beforeTarget");
    print("After Target: $afterTarget");
  } else {
    print("Target not found in the array.");
  }
}

void main() {
  List<int> arr = [1, 2, 3, 4, 5];
  int target = 5;
  List<int> rotatedArr = rotateToMiddle(arr, target);
  print(rotatedArr);
  splitArrayAroundTarget(rotatedArr, target);
}

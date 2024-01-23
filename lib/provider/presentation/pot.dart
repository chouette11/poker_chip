import 'package:poker_chip/model/entity/side_pot/side_pot_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pot.g.dart';

@riverpod
class HostSidePots extends _$HostSidePots {
  @override
  List<SidePotEntity> build() {
    return [];
  }

  void addSidePots(List<SidePotEntity> sidePots) {
    state = [...state, ...sidePots];
  }

  int totalValue() {
    int value = 0;
    for (final pot in state) {
      value += pot.size;
    }
    return value;
  }

  void clear() {
    state = [];
  }
}

@riverpod
class SidePots extends _$SidePots {
  @override
  List<int> build() {
    return [];
  }

  void addSidePot(int sidePotValue) {
    state = [...state, sidePotValue];
  }

  int totalValue() {
    int value = 0;
    for (final pot in state) {
      value += pot;
    }
    return value;
  }

  void clear() {
    state = [];
  }
}

@riverpod
class Pot extends _$Pot {
  @override
  int build() {
    return 0;
  }

  void potUpdate(int score) {
    state = state + score;
  }

  void clear() {
    state = 0;
  }
}
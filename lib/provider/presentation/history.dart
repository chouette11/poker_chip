import 'package:poker_chip/model/entity/history/history_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history.g.dart';

@Riverpod(keepAlive: true)
@riverpod
class History extends _$History {
  @override
  List<HistoryEntity> build() {
    return [];
  }

  void add(HistoryEntity history) {
    state = [...state, history];
  }
}

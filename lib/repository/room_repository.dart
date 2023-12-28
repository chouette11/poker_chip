import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/data/firestore_data_source.dart';

final roomRepositoryProvider =
    Provider<RoomRepository>((ref) => RoomRepository(ref));

class RoomRepository {
  RoomRepository(this.ref);

  final Ref ref;

  
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/message/message_entity.dart';

final apiProvider = Provider<ApiDataSource>((ref) => ApiDataSource(ref: ref));

class ApiDataSource {
  ApiDataSource({required this.ref});

  final Ref ref;

  ///
  /// Message
  ///
}

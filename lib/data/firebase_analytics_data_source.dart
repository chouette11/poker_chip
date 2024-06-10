import 'package:poker_chip/provider/domain_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsProvider =
Provider<FirebaseAnalyticsDataSource>((ref) => FirebaseAnalyticsDataSource(ref: ref));

class FirebaseAnalyticsDataSource {
  FirebaseAnalyticsDataSource({required this.ref});

  final Ref ref;

  Future<void> pressStart() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'button_press',
      parameters: <String, dynamic>{
        'button_name': 'start',
      },
    );
  }

  Future<void> pressMakeRoom() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'button_press',
      parameters: <String, dynamic>{
        'button_name': 'make_room',
      },
    );
  }

  Future<void> pressJoinRoom() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'button_press',
      parameters: <String, dynamic>{
        'button_name': 'join_room',
      },
    );
  }

  Future<void> joinSuccess() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'status',
      parameters: <String, dynamic>{
        'status_name': 'success_join',
      },
    );
  }

  Future<void> pressUsage() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'button_press',
      parameters: <String, dynamic>{
        'button_name': 'usage',
      },
    );
  }
}

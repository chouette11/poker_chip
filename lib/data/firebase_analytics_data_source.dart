import 'package:poker_chip/provider/domain_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsProvider =
Provider<FirebaseAnalyticsDataSource>((ref) => FirebaseAnalyticsDataSource(ref: ref));

class FirebaseAnalyticsDataSource {
  FirebaseAnalyticsDataSource({required this.ref});

  final Ref ref;

  Future<void> appOpen() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    analytics.logAppOpen();
  }

  Future<void> pressStart() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'start_game',
    );
  }

  Future<void> pressMakeRoom() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'make_room',
    );
  }

  Future<void> pressJoinRoom() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'join_room',
    );
  }

  Future<void> joinSuccess() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'success_join',
    );
  }

  Future<void> reconnect() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'reconnect',
    );
  }

  Future<void> pressUsage() async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics.logEvent(
      name: 'usage',
    );
  }
}

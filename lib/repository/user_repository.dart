import 'package:poker_chip/data/preferences_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepository(ref));

class UserRepository {
  UserRepository(this.ref);

  final Ref ref;

  /// ユーザーが起動したかを判別
  Future<bool> getIsLaunch() async {
    final pref = ref.read(preferencesProvider);
    final value = await pref.getBool(PrefKey.isLaunch.name);
    pref.setBool(PrefKey.isLaunch.name, true);
    return value ?? false;
  }

  /// ミュートかどうかを判別
  Future<bool> getIsMute() async {
    final pref = ref.read(preferencesProvider);
    final value = await pref.getBool(PrefKey.isMute.name);
    return value ?? false;
  }

  /// ミュートかどうかを変更
  Future<bool> changeIsMute() async {
    final pref = ref.read(preferencesProvider);
    final value = await pref.getBool(PrefKey.isMute.name);
    if (value == null) {
      await pref.setBool(PrefKey.isMute.name, true);
      return true;
    } else {
      pref.setBool(PrefKey.isMute.name, !value);
      return !value;
    }
  }

  /// 通知許可のダイアログの判別
  Future<bool> getIsNotiDialog() async {
    final pref = ref.read(preferencesProvider);
    final value = await pref.getBool(PrefKey.isNotificationDialog.name);
    pref.setBool(PrefKey.isNotificationDialog.name, true);
    return value ?? false;
  }
}

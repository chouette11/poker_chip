import 'package:poker_chip/data/preferences_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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

  /// ユーザーの名前を保存
  Future<void> saveName(String name) async {
    final pref = ref.read(preferencesProvider);
    pref.setString(PrefKey.name.name, name);
  }

  /// ユーザーの名前を取得
  Future<String?> getName() async {
    final pref = ref.read(preferencesProvider);
    final value = await pref.getString(PrefKey.name.name);
    return value;
  }

  Future<String> saveUID() async {
    final pref = ref.read(preferencesProvider);
    final value = const Uuid().v4();
    pref.setString(PrefKey.uid.name, value);
    return value;
  }

  /// ユーザーのIDを取得
  Future<String> getUID() async {
    final pref = ref.read(preferencesProvider);
    final value = await pref.getString(PrefKey.uid.name);
    return value ?? await saveUID();
  }
}

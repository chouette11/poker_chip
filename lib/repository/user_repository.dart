import 'package:flutter_template/data/firestore_data_source.dart';
import 'package:flutter_template/data/preferences_data_source.dart';
import 'package:flutter_template/model/entity/user/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepository(ref));

class UserRepository {
  UserRepository(this.ref);

  final Ref ref;

  /// ユーザーを追加
  Future<void> addUser(UserEntity userEntity) async {
    final firestore = ref.read(firestoreProvider);
    await firestore.insertUser(userEntity.toUserDocument());
  }

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

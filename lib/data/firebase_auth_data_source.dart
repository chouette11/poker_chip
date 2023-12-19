import 'package:flutter_template/model/entity/user/user_entity.dart';
import 'package:flutter_template/provider/domain_providers.dart';
import 'package:flutter_template/provider/presentation_providers.dart';
import 'package:flutter_template/repository/user_repository.dart';
import 'package:flutter_template/util/constant/color_constant.dart';
import 'package:flutter_template/util/constant/text_style_constant.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider =
    Provider<FirebaseAuthDataSource>((ref) => FirebaseAuthDataSource(ref: ref));

class FirebaseAuthDataSource {
  FirebaseAuthDataSource({required this.ref});

  final Ref ref;

  /// 自動ログイン
  Future<void> autoLogin() async {
    final auth = ref.read(firebaseAuthProvider);
    final userRepo = ref.read(userRepositoryProvider);
    final user = auth.currentUser;
    if (user == null || user.email == null) {
      await auth.signInAnonymously();
      final token = await FirebaseMessaging.instance.getToken();
      final uid = ref.read(uidProvider);
      final userEntity = UserEntity(uid: uid, token: token!);
      await userRepo.addUser(userEntity);
    }
  }

  /// 通知許可
  Future<void> requestNotification(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final setting = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final isNotification =
        await ref.read(userRepositoryProvider).getIsNotiDialog();
    if (setting.authorizationStatus.name != "authorized" && !isNotification) {
      showDialog(
        context: context,
        builder: (context) => const NotificationDialog(),
      );
    }
  }
}

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: ColorConstant.back,
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    '''現在ユーザー数が少なくてマッチングせず困っています...\n他のユーザーがマッチングを開始した時に通知を送らせてください！''',
                    style: TextStyleConstant.normal16,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      AppSettings.openAppSettings(
                          type: AppSettingsType.notification);
                    },
                    child: Container(
                      width: 72,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: ColorConstant.accent,
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstant.black10,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                          child: Text(
                        'いいよ！',
                        style: TextStyleConstant.normal12,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset('assets/images/notification.png'),
          Positioned(
            left: 12,
            top: 12,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                height: 36,
                width: 36,
                decoration: const BoxDecoration(
                  color: ColorConstant.back,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: ColorConstant.black100,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

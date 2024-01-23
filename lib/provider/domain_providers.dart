import 'package:poker_chip/page/game/host/host.dart';
import 'package:poker_chip/page/game/host/host_page.dart';
import 'package:poker_chip/page/game/participant/ori.dart';
import 'package:poker_chip/page/game/participant/paticipant_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poker_chip/page/root/root_page.dart';
import 'package:uuid/uuid.dart';

final firebaseAuthProvider = Provider((_) => FirebaseAuth.instance);

final uuidProvider = Provider((_) => const Uuid());

/// ページ遷移のプロバイダ
final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (BuildContext context, GoRouterState state) async {
          // final bool launched =
          //     await ref.read(userRepositoryProvider).getIsLaunch();
          // if (!launched) {
          //   ref.read(isTutorialProvider.notifier).update((state) => true);
          //   return '/tutorial';
          // }
          // return null;
        },
        builder: (context, state) => const RootPage(),
        routes: [
          GoRoute(
            path: 'host_ex',
            builder: (context, state) => const Host(),
          ),
          GoRoute(
            path: 'ori',
            builder: (context, state) => const Ori(),
          ),
          GoRoute(
            path: 'host',
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(const HostPage()),
          ),
          GoRoute(
            path: 'participant',
            pageBuilder: (context, state) => _buildPageWithAnimation(
                ParticipantPage(id: state.extra as String?)),
          ),
        ],
      ),
    ],
  ),
);

CustomTransitionPage _buildPageWithAnimation(Widget page) {
  return CustomTransitionPage(
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
    transitionDuration: const Duration(milliseconds: 0),
  );
}

import 'package:flutter_template/data/firebase_auth_data_source.dart';
import 'package:flutter_template/repository/user_repository.dart';
import 'package:flutter_template/util/environment/environment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/provider/audio_provider.dart';
import 'package:flutter_template/provider/domain_providers.dart';
import 'package:flutter_template/util/constant/color_constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const flavorName = String.fromEnvironment('flavor');
  final flavor = Flavor.values.byName(flavorName);
  await Firebase.initializeApp(
    options: firebaseOptionsWithFlavor(flavor),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    Future(() async {
      final isMute = await ref.read(userRepositoryProvider).getIsMute();
      ref.read(isMuteProvider.notifier).update((state) => isMute);
      ref.read(authProvider).autoLogin();
      final cache = ref.read(audioCacheProvider);
      final path = await cache.load('audios/button7.mp3');
      final path2 = await cache.load('audios/button8.mp3');
      ref.read(buttonSoundProvider.notifier).update((state) => path.path);
      ref.read(notSoundProvider.notifier).update((state) => path2.path);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: ThemeData(
        primaryColor: ColorConstant.black100,
        fontFamily: 'Kaisei_Decol',
        dividerColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

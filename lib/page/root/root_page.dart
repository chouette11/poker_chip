import 'package:go_router/go_router.dart';
import 'package:poker_chip/page/game/component/chips.dart';
import 'package:poker_chip/page/game/component/hole.dart';
import 'package:poker_chip/page/game/component/pot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/root/setting_button.dart';
import 'package:poker_chip/page/game/host/host_page.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';

class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorConstant.back,
        body: SafeArea(
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/board.png',
                    fit: BoxFit.fitHeight,
                    height: height - 36,
                    width: width,
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: SettingButton()
                ),
                Positioned(
                  top: height * 0.3,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PotWidget(true),
                  ),
                ),
                Positioned(
                  bottom: height * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => context.go('/host'),
                          child: const Text('部屋作成')),
                      const SizedBox(width: 32),
                      ElevatedButton(
                          onPressed: () {
                            final flavor = ref.read(flavorProvider);
                            if (flavor == 'dev') {
                              context.go('/participant', extra: roomToPeerId(000000));
                            }
                            context.go('/participant');
                          },
                          child: const Text('参加する')),
                    ],
                  ),
                ),
                Positioned(bottom: height * 0.2, child: const Hole(true)),
                Positioned(bottom: height * 0.08, left: 0, child: const Chips()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:go_router/go_router.dart';
import 'package:poker_chip/page/root/component/mute_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/page/root/component/main_button.dart';
import 'package:poker_chip/page/root/component/title_icon.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:just_audio/just_audio.dart';

final _localPlayer = AudioPlayer(userAgent: "local");

class RootPage extends ConsumerStatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorConstant.back,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TitleIcon(),
                    const SizedBox(height: 52),
                    MainButton(
                      onTap: () async {
                        context.push('/host');
                        
                      },
                      text: '部屋作成',
                    ),
                    const SizedBox(height: 32),
                    MainButton(
                      onTap: () async {
                        context.push('/read_qr');
                      },
                      text: '参加する',
                    ),
                    const SizedBox(height: 32),
                    MainButton(
                      onTap: () async {
                        context.push('/ori');
                      },
                      text: 'ori',
                    ),
                    MainButton(
                      onTap: () async {
                        context.push('/host_ex');
                      },
                      text: 'host',
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: MuteButton(_localPlayer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

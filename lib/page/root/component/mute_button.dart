import 'package:flutter_template/provider/audio_provider.dart';
import 'package:flutter_template/repository/user_repository.dart';
import 'package:flutter_template/util/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class MuteButton extends ConsumerWidget {
  const MuteButton(this.localPlayer, {super.key});
  final AudioPlayer localPlayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMute = ref.watch(isMuteProvider);
    return IconButton(
      onPressed: () async {
        print(isMute);
        if (isMute) {
          localPlayer.setAsset('assets/audios/title.mp3');
          localPlayer.play();
        } else {
          final player = ref.read(justAudioProvider);
          player.stop();
          localPlayer.stop();
        }
        final value = await ref.read(userRepositoryProvider).changeIsMute();
        print('value: $value');
        ref.read(isMuteProvider.notifier).update((state) => value);
      },
      icon: isMute
          ? const Icon(
              Icons.volume_off,
              color: ColorConstant.black100,
            )
          : const Icon(
              Icons.volume_up,
              color: ColorConstant.black100,
            ),
    );
  }
}

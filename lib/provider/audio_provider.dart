import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart' as just;
import 'package:riverpod/riverpod.dart';

final audioProvider = Provider((_) {
  final player = AudioPlayer();
  return player;
});

final justAudioProvider = Provider((ref) {
  final player = just.AudioPlayer();
  final isMute = ref.watch(isMuteProvider);
  if (isMute) {
    player.setVolume(0.0);
  } else {
    player.setVolume(1.0);
  }
  return player;
});

final isMuteProvider = StateProvider((ref) => false);

final audioCacheProvider = Provider((_) => AudioCache());

final buttonSoundProvider = StateProvider<String>((ref) => '');

final notSoundProvider = StateProvider((ref) => '');

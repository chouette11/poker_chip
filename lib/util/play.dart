import 'package:flutter_template/provider/audio_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> play(WidgetRef ref, String path) async {
  final audio = ref.read(audioProvider);
  await audio.play(DeviceFileSource(path));
}
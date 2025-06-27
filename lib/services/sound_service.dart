import 'package:just_audio/just_audio.dart';

AudioPlayer? _player;

Future<void> initFunnySound() async {
  _player = AudioPlayer();
  await _player!.setAsset('voice/Fairy.wav');
}

void playFunnySound() {
  if (_player != null) {
    _player!.seek(Duration.zero);
    _player!.play();
  }
} 
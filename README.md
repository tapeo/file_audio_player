# FileAudioPlayer

Audio player for local files. This plugin have ducking support to reduce the main audio volume while playing background music

## Usage

```dart
    FileAudioPlayer audioPlayer = FileAudioPlayer();

    audioPlayer.start(filePath);

    audioPlayer.stop();

    audioPlayer.pause();

    audioPlayer.resume();
```
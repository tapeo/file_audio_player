# FileAudioPlayer

Audio player for local files. This plugin have ducking support to reduce the main audio volume while playing background music.

Link to pub.dev package: [fileaudioplayer](https://pub.dev/packages/fileaudioplayer)

## Installation
In the `dependencies` section of the `pubspec.yaml` project file add:

```
fileaudioplayer: <latest_version>
```

## Usage

```dart
    FileAudioPlayer audioPlayer = FileAudioPlayer();

    audioPlayer.start(filePath);

    audioPlayer.stop();

    audioPlayer.pause();

    audioPlayer.resume();
```
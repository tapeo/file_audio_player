import 'dart:async';
import 'dart:io';

import 'package:fileaudioplayer/fileaudioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FileAudioPlayer player = new FileAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            new FlatButton(
              child: new Text("Start"),
              onPressed: () {
                start();
              },
            ),
            new FlatButton(
              child: new Text("Stop"),
              onPressed: () {
                stop();
              },
            ),
            new FlatButton(
              child: new Text("Pause"),
              onPressed: () {
                pause();
              },
            ),
            new FlatButton(
              child: new Text("Resume"),
              onPressed: () {
                resume();
              },
            )
          ],
        )),
      ),
    );
  }

  Future<void> start() async {
    final ByteData data =
        await rootBundle.load('assets/synthesized-audio.mp3');
    Directory tempDir = await getApplicationDocumentsDirectory();
    File tempFile = File('${tempDir.path}/demo.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    String mp3Uri = tempFile.uri.toString();

    print("start");

    await player.start(mp3Uri);

    print("end");
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> resume() async {
    await player.resume();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  AudioStream stream = new AudioStream();

  Future<void> callAudio(String action) async{
    if(action == "start"){

      final ByteData data = await rootBundle.load('assets/synthesized-audio.mp3');
      Directory tempDir = await getApplicationDocumentsDirectory();
      File tempFile = File('${tempDir.path}/demo.mp3');
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
      String mp3Uri = tempFile.uri.toString();

      print("start");
      await stream.start(mp3Uri);
      print("end");
    }else if(action == "stop"){
      await stream.stop();
    }else if(action == "pause"){
      await stream.pause();
    }else{
      await stream.resume();
    }
  }

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
                new RaisedButton(
                  child: new Text("Start"),
                  onPressed: (){
                    callAudio("start");
                  },
                ),
                new RaisedButton(
                  child: new Text("Stop"),
                  onPressed: (){
                    callAudio("stop");
                  },
                ),
                new RaisedButton(
                  child: new Text("Pause"),
                  onPressed: (){
                    callAudio("pause");
                  },
                ),
                new RaisedButton(
                  child: new Text("Resume"),
                  onPressed: (){
                    callAudio("resume");
                  },
                )
              ],
            )
        ),
      ),
    );
  }
}

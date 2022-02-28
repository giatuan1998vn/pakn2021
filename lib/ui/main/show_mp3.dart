import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';


class showMP3 extends StatefulWidget {
  final String mp3;
  final String linkMp3;

  const showMP3({Key key, this.mp3,this.linkMp3}) : super(key: key);
  @override
  _ExampleAppState createState() => new _ExampleAppState();
}

class _ExampleAppState extends State<showMP3> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  var player1 = new AudioPlayer();
  StreamSubscription _positionSubscription;
  String tenMP3= "audio.mp3";
  @override
  void initState(){
    super.initState();
    initPlayer();
    tenMP3 = widget.mp3;
  }
  @override
  void dispose(){
    super.dispose();
    player1.stop();
    _position;
  }
  void Player(){
    player1.play("https://luan.xyz/files/audio/ambient_c_motion.mp3");
    if (mounted) {
      setState(() {
      });
    }
  }
  GetDataMP3() async {
    // String getData = await CongAPI.getDataMP3(title);
    // var data = json.decode(getData)["async"];
    player1.play(widget.linkMp3);
    if (mounted) {
      setState(() {
      });
    }
  }
  void initPlayer(){
    // player1 = new AudioPlayer();
    // audioCache = new AudioCache(fixedPlayer: player1);

    player1.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => _duration = d);
    });

    // player1.onAudioPositionChanged.listen((Duration  p)  {
    // print('Current position: $p');
    //     setState(() => _position = p);
    // });


    player1.onAudioPositionChanged
        .listen((p) => setState(() => _position = p));

  }


  Widget _tab(List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children
              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
              .toList(),
        ),
      ),
    );
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }

  Widget slider() {
    return Slider(
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });});
  }

  Widget localAsset() {
    return _tab([
      SizedBox(height: 50,),
      Text('Play  \' $tenMP3 \':'
        ,style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            fontSize: 18),),
      _btn('Play',() => GetDataMP3()),
      _btn('Pause',() => player1.pause()),
      _btn('Stop', () => player1.stop()),
      slider(),
      Text(_position.toString())
    ]);
  }

  void seekToSecond(int second){
    Duration newDuration = Duration(seconds: second);

    player1.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(

        body: Center(child: TabBarView(
          children: [localAsset()],
        ),),
      ),
    );
  }
}
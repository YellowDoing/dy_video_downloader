import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:vd/video.dart';
import 'package:video_player/video_player.dart';

class PlayerPage extends StatefulWidget {

  final  Video _video;
  final Size _size;


  PlayerPage(this._video,this._size);

  @override
  _PlayerPageState createState() => _PlayerPageState();


}

class _PlayerPageState extends State<PlayerPage> {
  var videoPlayerController;
  var chewieController;

  @override
  void initState() {
    videoPlayerController = new VideoPlayerController.file(new File(widget._video.path));
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: widget._size.aspectRatio,
      autoPlay: true,
      looping: true,
      allowFullScreen: false
    );
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Chewie(
        controller: chewieController,
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}

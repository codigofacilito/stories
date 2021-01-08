import 'dart:io';
import 'dart:typed_data';

import 'package:appflutter/Data/Database.dart';
import 'package:appflutter/Model/User.dart';
import 'package:appflutter/Pages/GalleryPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class VideoViewerPage extends StatefulWidget{
  var save;
  AssetEntity asset;
  VideoViewerPage(this.save,this.asset);
  @override
  State<StatefulWidget> createState() => _VideoViewerPageState();

}

class _VideoViewerPageState extends State<VideoViewerPage>{
  VideoPlayerController _controller;
  bool initialized=false;


  @override
  void initState() {
    _initVideo();
  }

  _initVideo()async{
    _controller=VideoPlayerController.file(await widget.asset.file)
        ..setLooping(true)
        ..initialize().whenComplete(() => setState(() {
          initialized=true;
        }) )
        ..play();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     backgroundColor: Colors.black,
     body: initialized?
   Stack(children: [GestureDetector(
     onTap: playOrPause ,
     child: Center(child:AspectRatio(
       aspectRatio: _controller.value.aspectRatio,
       child: VideoPlayer(_controller),
     ),
   )),
     Align(alignment: Alignment.bottomRight,
       child: FlatButton(onPressed:()=>saveStory(context),color: Colors.white,
         child: Text("Compartir"),),)

   ],):Center(child: CircularProgressIndicator(),));
  }

  saveStory(context){
    widget.save(widget.asset).whenComplete(() => Navigator.pop(context));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  playOrPause(){
    setState(() {
      if(_controller.value.isPlaying)
        _controller.pause();
      else
        _controller.play();
    });
  }
}
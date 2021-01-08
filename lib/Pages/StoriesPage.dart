import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:appflutter/Data/Database.dart';
import 'package:appflutter/Model/Story.dart';
import 'package:appflutter/Model/User.dart';
import 'package:appflutter/Pages/GalleryPage.dart';
import 'package:appflutter/Pages/ImageViewerPage.dart';
import 'package:appflutter/Pages/VideoViewerPage.dart';
import 'package:appflutter/Widget/AnimatedBar.dart';
import 'package:appflutter/Widget/UserInfo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../Common.dart';

class StoriesPage extends StatefulWidget{
  User user;
  StoriesPage(this.user);
  @override
  State<StatefulWidget> createState() => _StoriesPageState();

}

class _StoriesPageState extends State<StoriesPage> with SingleTickerProviderStateMixin{
  StreamSubscription<Event>onAddedSubs;
  StreamSubscription<Event>onChangeSubs;
  VideoPlayerController _videoPlayerController;
  List<Story>stories=List();
  int _currentIndex=0;
  AnimationController _animationController;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     backgroundColor: Colors.black,
     body: (stories.isNotEmpty)?showStory():Center(child: CircularProgressIndicator(),),
   );
  }

  showStory(){
    Story story=stories[_currentIndex];
    return
      GestureDetector(
        onTapDown:(details)=>_onTap(details,story,isTapDown: true) ,
          onTapUp:(details)=> _onTap(details,story,) ,
          child:Stack(children: [
      Container(
        constraints: BoxConstraints.expand(),
        child: loadImageOrVideo(story),
      ),
      Positioned(
          top:40.0,
          left:10.0,
    right: 10.0,child:
      Column(children: [
        Row(children: stories.asMap().map((i, value) => MapEntry(i, AnimatedBar(_animationController,i,_currentIndex))).values.toList(),)
        ,Padding(padding: const EdgeInsets.symmetric(horizontal: 1.5,vertical: 10.0),child:
        UserInfo(widget.user),)],)),


    ],));
  }

  _onTap(var details,Story story,{bool isTapDown=false}){
    final double screenWidth=MediaQuery.of(context).size.width;
    final double dx=details.localPosition.dx;

    if(dx<screenWidth/3) {
      if (isTapDown)
        setState(() {
          if (_currentIndex - 1 >= 0) {
            _currentIndex -= 1;
            _loadAsset(stories[_currentIndex]);
          }
        });
    }else if(dx >2*screenWidth/3){
            if(isTapDown){
              setState(() {
                if(_currentIndex+1<stories.length){
                  _currentIndex+=1;
                  _loadAsset(stories[_currentIndex]);
                }else if(_currentIndex +1 >=stories.length){
                  Navigator.pop(context);
                }
              });
            }
    }else{
      if(story.type=="Video"){
        if(_videoPlayerController.value.isPlaying){
          _videoPlayerController.pause();
          _animationController.stop();
        }else{
          _videoPlayerController.play();
          _animationController.forward();
        }
      }else{
        if(isTapDown){
          _animationController.stop();
        }else{
          _animationController.forward();
        }
      }
    }
  }

  loadImageOrVideo(Story story){
    switch(story.type){
      case "Image":
        return Image.network(
            story.url,
        fit: BoxFit.cover,);
      case "Video":
        if(_videoPlayerController!=null && _videoPlayerController.value.initialized){
          return FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoPlayerController.value.size.width,
              height: _videoPlayerController.value.size.height,
              child: VideoPlayer(_videoPlayerController),
            ),
          );
        }
    }
    return SizedBox.shrink();
  }

  @override
  void initState() {
    onAddedSubs=Database.tableStory.orderByChild("userId").equalTo(widget.user.key).onChildAdded.listen(onEntryAdded);
    onChangeSubs=Database.tableStory.orderByChild("userId").equalTo(widget.user.key).onChildChanged.listen(onEntryChanged);
    _animationController=AnimationController(vsync: this );
    _animationController.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        _animationController.stop();
        _animationController.reset();

        setState(() {
          if(_currentIndex+1<stories.length){
            _currentIndex+=1;
            _videoPlayerController=null;
            _loadAsset(stories[_currentIndex]);
          }else{
            Navigator.pop(context);
          }
        });
      }

    });
  }

  onEntryAdded(Event event){
    setState(() {
      stories.add(Story.getStory(event.snapshot));
      _loadAsset(stories[_currentIndex]);
    });
  }

  onEntryChanged(Event event){
    Story oldStory=stories.singleWhere((element) {
      return element.key==event.snapshot.key;
    } );
    setState(() {
      stories[stories.indexOf(oldStory)]=Story.getStory(event.snapshot);
      _loadAsset(stories[_currentIndex]);
    });
  }

  _loadAsset(Story story){
    _videoPlayerController?.dispose();
    _animationController.stop();
    _animationController.reset();
    switch(story.type){
      case "Image":
        _animationController.duration=Duration(seconds: 8);
        _animationController.forward();
        break;

      case "Video":
        _videoPlayerController=VideoPlayerController.network(story.url)
        ..initialize().then((_){
          setState(() {
            if(_videoPlayerController.value.initialized){
              _animationController.duration=_videoPlayerController.value.duration;
              _videoPlayerController.play();
              _animationController.forward();
            }
          });
        });
        break;
    }
  }

  @override
  void dispose() {
    onAddedSubs.cancel();
    onChangeSubs.cancel();
    _videoPlayerController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

}
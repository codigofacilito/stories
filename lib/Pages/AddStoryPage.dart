import 'dart:io';
import 'dart:typed_data';

import 'package:appflutter/Data/Database.dart';
import 'package:appflutter/Model/Story.dart';
import 'package:appflutter/Model/User.dart';
import 'package:appflutter/Pages/GalleryPage.dart';
import 'package:appflutter/Pages/ImageViewerPage.dart';
import 'package:appflutter/Pages/VideoViewerPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

import '../Common.dart';

class AddStoryPage extends StatefulWidget{
  User user;
  AddStoryPage(this.user);
  @override
  State<StatefulWidget> createState() => _AddStoryPageState();

}

class _AddStoryPageState extends State<AddStoryPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return GalleryPage(onSelect);
  }

  onSelect(AssetEntity assetEntity){
    Navigator.push(context, MaterialPageRoute(builder: (_){
      return(assetEntity.type==AssetType.image)?
         ImageViewerPage(saveStory, assetEntity):VideoViewerPage(saveStory, assetEntity);
    }));
  }

  saveStory(AssetEntity assetEntity)async{
    Common.saveImage(await assetEntity.file).then((value)async{
      if(value!=null)
        await Database.tableStory.push().set(Story(
          url: value,
            type: (assetEntity.type==AssetType.image)?"Image":"Video",
            userId: widget.user.key,
        ).toMap());

    });
  }

}
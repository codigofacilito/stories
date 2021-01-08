import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageViewerPage extends StatelessWidget{
  var save;
  AssetEntity asset;
  ImageViewerPage(this.save,this.asset);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child:Stack(
          children: [
            FutureBuilder<File>(
                future:asset.file,builder:(_,snapshot){
              final file=snapshot.data;
              if(file==null)return Container();
              return Center(child:Image.file(file));
            }),
            Align(alignment: Alignment.bottomRight,
            child: FlatButton(onPressed:()=>saveStory(context),color: Colors.white,
            child: Text("Compartir"),),)
          ],
        )
      ),
    );
  }

  saveStory(context){
    save(asset).whenComplete(() => Navigator.pop(context));
  }

}
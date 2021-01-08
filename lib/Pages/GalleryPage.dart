import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPage extends StatefulWidget{
  var onSelect;
  RequestType requestType;
  GalleryPage(this.onSelect,{this.requestType=RequestType.common});
  @override
  State<StatefulWidget> createState() => _GalleryPageState();
  
  
}

class _GalleryPageState extends State<GalleryPage>{
  List<AssetEntity> assets=List();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     body: GridView.builder(
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 3

         ),
         itemCount: assets.length,
         itemBuilder: (_,index){
           return assetThumbnail(assets[index]);
         }),
   );
  }

  assetThumbnail(AssetEntity assetEntity){
    return FutureBuilder<Uint8List>(
        future: assetEntity.thumbData,
        builder: (_,snapshot){
          final bytes=snapshot.data;
          if(bytes==null)return CircularProgressIndicator();

          return GestureDetector(
            onTap: (){
              Navigator.pop(context);
              widget.onSelect(assetEntity);
            },
            child: Stack(children: [
              Positioned.fill(child: Image.memory(bytes)),

              if(assetEntity.type==AssetType.video)
                Center(
                  child: Container(
                    color: Colors.green,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                )
            ],),
          );
    });

  }
  @override
  void initState() {
    _fetchAssets();
  }

  _fetchAssets()async{
    final albums=await PhotoManager.getAssetPathList(onlyAll: true,type: widget.requestType);
    final recentAlbum =albums.first;

    final recentAssets= await recentAlbum.getAssetListRange(start: 0,end: 1000000);

    setState(() {
      this.assets=recentAssets;
    });
  }
}
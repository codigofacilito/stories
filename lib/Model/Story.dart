import 'package:appflutter/Data/Database.dart';
import 'package:firebase_database/firebase_database.dart';

class Story{
  String key;
  String url;
  String type;
  String userId;
  Story({this.key,this.url,this.type,this.userId});

  Map<String ,dynamic> toMap(){
    return {
      "key":this.key,
      "url":this.url,
      "type":this.type,
      "userId":this.userId
    };
  }

  Story.getStory(DataSnapshot snapshot){
    this.key=snapshot.key;
    this.url=snapshot.value["url"];
    this.type=snapshot.value["type"];
    this.userId=snapshot.value["userId"];
  }

  static Future<bool>hasStory(String userId)async{
    return (await Database.tableStory.orderByChild('userId').equalTo(userId).once()).value!=null;
  }
}
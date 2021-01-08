import 'package:appflutter/Model/Story.dart';
import 'package:firebase_database/firebase_database.dart';

class User{
  String key;
  String name;
  String image;

  User({this.key,this.name,this.image});

  Map<String ,dynamic> toMap(){
    return {
      "key":this.key,
      "name":this.name,
      "image":this.image
    };
  }

  User.getUser(DataSnapshot snapshot){
    this.key=snapshot.key;
    this.name=snapshot.value["name"];
    this.image=snapshot.value["image"];
  }

  hasStory(){
    return Story.hasStory(this.key);
  }
}
import 'package:firebase_database/firebase_database.dart';

class Database{
  static DatabaseReference database=FirebaseDatabase.instance.reference().child("Stories");

  static DatabaseReference tableUser=database.child("User");
  static DatabaseReference tableStory=database.child("Story");
}
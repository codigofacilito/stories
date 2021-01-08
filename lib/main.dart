import 'dart:async';

import 'package:appflutter/Data/Database.dart';
import 'package:appflutter/Model/User.dart';
import 'package:appflutter/Pages/AddStoryPage.dart';
import 'package:appflutter/Pages/FormUserPage.dart';
import 'package:appflutter/Pages/StoriesPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<Event>onAddedSubs;
  StreamSubscription<Event>onChangeSubs;
  List<User>users=List();
  @override
  void initState() {
    onAddedSubs=Database.tableUser.onChildAdded.listen(onEntryAdded);
    onChangeSubs=Database.tableUser.onChildChanged.listen(onEntryChanged);
  }

  onEntryAdded(Event event){
    setState(() {
      users.add(User.getUser(event.snapshot));
    });
  }

  onEntryChanged(Event event){
    User oldUser=users.singleWhere((element) {
      return element.key==event.snapshot.key;
    } );
    setState(() {
      users[users.indexOf(oldUser)]=User.getUser(event.snapshot);
    });
  }

  @override
  void dispose() {
    onAddedSubs.cancel();
    onChangeSubs.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: users.length,
          itemBuilder: (BuildContext context,int index){
            return Padding(padding: EdgeInsets.symmetric(horizontal: 10),child:
                Column(children: [
              GestureDetector(
                onLongPress:()=>showMenu(users[index]) ,
                onTap: ()async{
                  bool hasStory=await users[index].hasStory();
                  goAddStoryPage(users[index],hasStory: hasStory);
                },
                child:
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage:NetworkImage(users[index].image) ,
                ),
              ),
                Text(users[index].name)],));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>
              FormUserPage()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  goAddStoryPage(User user,{bool hasStory=false}){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>
    (hasStory)?StoriesPage(user):AddStoryPage(user)));
  }

  showMenu(User user){
    showModalBottomSheet(context: context, builder: (contexto){
      return Container(
        child: Wrap(children: [
          ListTile(
            title: Text("Agregar contenido a tu historia"),
            onTap: (){
              Navigator.pop(contexto);
              goAddStoryPage(user);
            },
          )
        ],),
      );
    });
  }


}

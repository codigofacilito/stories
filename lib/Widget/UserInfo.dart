import 'package:appflutter/Model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInfo extends  StatelessWidget{
  User user;
  UserInfo(this.user);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(children: [
      CircleAvatar(
        radius: 20.0,
        backgroundColor: Colors.grey[300],
        backgroundImage: NetworkImage(user.image),
      ),
      const SizedBox(width: 10.0,),
      Expanded(child: Text(user.name,style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w600),)),
      IconButton(icon: Icon(Icons.close,size: 30.0,color: Colors.white,), onPressed: ()=>Navigator.pop(context))
    ],);
  }

  Container _buildContainer(double width,Color color){
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8
        ),
        borderRadius: BorderRadius.circular(3.0)
      ) ,
    );
  }

}
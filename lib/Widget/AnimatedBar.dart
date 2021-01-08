import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedBar extends  StatelessWidget{
  final AnimationController animationController;
  final int position;
  final int currentIndex;
  AnimatedBar(this.animationController,this.position,this.currentIndex);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Flexible(child:
    Padding(padding: const EdgeInsets.symmetric(horizontal: 1.5),
    child: LayoutBuilder(
      builder: (context,constraints){
        return Stack(children: [
          _buildContainer(
            double.infinity,
            position<currentIndex?Colors.white:Colors.white.withOpacity(0.5)
          ),
          position==currentIndex?
              AnimatedBuilder(animation: animationController, builder:(context,child){
                return _buildContainer(constraints.maxWidth* animationController.value, Colors.white);
              }):const SizedBox.shrink()
        ],);
      },
    ),));
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
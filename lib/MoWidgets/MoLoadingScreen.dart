
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:moction/MoWidgets/MoColor.dart';

class MoLoadingScreen extends StatefulWidget{



  /// the duration that a color is changed;
  Duration duration;

  /// the time it takes for one animation to change to another one
  Duration animationDuration;

  MoLoadingScreen(this.duration,this.animationDuration);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MoLoadingScreenState();
  }



}

class _MoLoadingScreenState extends State<MoLoadingScreen>{


  Timer timer;

  double currentOpacity;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentOpacity = MoColor.getRandomOpacity();
    timer = new Timer.periodic(widget.duration,  changeColor);
  }

  changeColor(Timer timer)
  {
    setState(() {
      currentOpacity = MoColor.getRandomOpacity(except: this.currentOpacity);
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getBody(context);
  }


  Widget getBody(BuildContext context)
  {
    return  AnimatedContainer(
      height: double.infinity,
            width: double.infinity,
            color: Theme.of(context).primaryColor.withOpacity(this.currentOpacity),
            duration: widget.animationDuration,
      child: new Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    //print("timer of loading was disposed");
  }


}
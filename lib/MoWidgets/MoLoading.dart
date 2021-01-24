import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class MoLoading extends StatefulWidget{

  List<String> showTexts;
  int timerTime;
  VoidCallback doThisWhenDone;
  Color textColor;

  MoLoading({this.showTexts,this.timerTime,this.doThisWhenDone,this.textColor});



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MoLoadingState();
  }


}

class MoLoadingState extends State<MoLoading>{


  Timer timer;
  int index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    index = 0;
    timer = Timer.periodic(Duration(seconds: widget.timerTime), changeText);

  }

  changeText(Timer timer)
  {
    if(index==widget.showTexts.length-1){
      timer.cancel();
      widget.doThisWhenDone();
    }else{
      setState(() {
        index+=1;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
          child: new Text(
            widget.showTexts[index],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30,color: MoNotNull.color(widget.textColor)),
          )
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(timer!=null){
      timer.cancel();
    }
  }

}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moction/Test/Tools.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/MoStopWatch/FormatTime.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class MoStopWatch extends StatefulWidget
{
  Tools tool;
  ThemeData themeData;
  MoStopWatch(this.tool,this.themeData);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<MoStopWatch> {


  Timer timer;
  Stopwatch stopwatch;



  void initState()
  {
    super.initState();

    initClass();
  }

  initClass()
  {
    stopwatch = new Stopwatch();

    timer = new Timer.periodic(new Duration(milliseconds: 10), callBack);
  }

  callBack(Timer timer)
  {
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.themeData,
      child: new Scaffold(
          appBar: getAppBar("Stopwatch"),
          body: getBody(),
      ),
    );

//    GestureDetector(
//        onTap: onTapStartButton,
//        child:
    }

   Widget getAppBar(String title)
  {
    return new AppBar(
      elevation: 0.0,
      title: new Text(title),
      centerTitle: true,
    );
  }


  Widget getBody() {
    final TextStyle timerTextStyle = const TextStyle(fontSize: 60.0, color:Colors.black);
    String newTime = stopwatch.elapsedMilliseconds.toString();
    return Stack(
      alignment: Alignment.bottomCenter,
        children: <Widget>[

          InkWell(
                splashColor: getColorStartButton(),
                onTap: onTapStartButton,
                child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                        FormatTime.readableForm(newTime), textAlign: TextAlign.center,
                        style: timerTextStyle),
                  new Text("Tap on the screen to "+getTextStartButton(), style: TextStyle(color: Colors.black54,fontSize: 20),),
                ],
              )),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(

              children: <Widget>[
                Expanded(child: resetButton()),
                new SizedBox(width: 6.0,),
                Expanded(child:  getSaveButton(),),
              ],
            ),
          )
        ],
    );
  }

  Widget getSaveButton()
  {
    return new MoButton(
        text: "Save",
        textColor: widget.themeData.accentColor,
        iconData: Icons.check,
        color: Colors.grey,
        spaceBetweenTI: 7.0,
        radius: 100.0,
        onTap: (){
          widget.tool.tool.title = stopwatch.elapsedMilliseconds.toString();
          Navigator.pop(context);
        },

    );
  }



  void onTapStartButton()
  {
    if(this.stopwatch.isRunning){
      this.stopwatch.stop();
    }else{
      this.stopwatch.start();
    }
  }

  String getTextStartButton()
  {
    return (this.stopwatch.isRunning)?"Stop":"Start";
  }

  Color getColorStartButton()
  {
    Color newC = (this.stopwatch.isRunning)?Colors.red:Colors.black;

    return newC;
  }


  Widget resetButton()
  {
    return new MoButton(
      text: "Reset",
      iconData: Icons.highlight_off,
      spaceBetweenTI: 7.0,
      color: Colors.grey,
      textColor: widget.themeData.accentColor,
      radius: 100.0,

      onTap: (){
        if(stopwatch.isRunning){
          stopwatch.stop();
        }
        stopwatch.reset();
      },
    );
  }

  dispose()
  {
    timer.cancel();
    super.dispose();
  }



}

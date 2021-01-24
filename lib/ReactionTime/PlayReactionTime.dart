import 'dart:async';

import 'package:moction/ReactionTime/ReactionTime.dart';
import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoAppBar.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/MoWidgets/MoState.dart';
import 'package:moction/MoWidgets/MoLoading.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoPadding.dart';

class PlayReactionTime extends StatefulWidget{

  ReactionTime reactionTime;
  ThemeData themeData;

  PlayReactionTime(this.reactionTime);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PlayReactionTimeState();
  }


}

class PlayReactionTimeState extends State<PlayReactionTime>{


  Timer run;

  MoState moState;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initClass();
  }

  void initClass()
  {

    this.moState = new MoState(MoState.WAIT);
    print(widget.reactionTime.numberOfObjects.number.toString());

  }

  void update(Timer timer)
  {
    //print("update");
    if(widget.reactionTime.isDone()){
      /// the test objects are done
      /// show the results and show a retry button
      print("the program is done");
      timer.cancel();
      this.moState.setState(MoState.WAIT);
      print(widget.reactionTime.content.getResults());
      setState(() {

      });

    }else{


        setState(() {
          widget.reactionTime.type.activateAllChoices(widget.reactionTime.numberOfObjects.isFirstContent());
          widget.reactionTime.type.checkSkip();
          widget.reactionTime.content.updateContent();
          widget.reactionTime.numberOfObjects.sub1();
          widget.reactionTime.timer.updateTime();

        });

    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // print(widget.reactionTime.timer.time.toString());
    return Scaffold(
        appBar: getAppBar(),
          body: getBody(),
      backgroundColor: MoNotNull.color(widget.reactionTime.content.color,returnThis: Theme.of(context).primaryColor),
    );
  }


  Widget getAppBar()
  {
    //if(this.moState.start()){
      return MoAppBar.getAppBar("Reaction Test", context,color: widget.reactionTime.content.color);
   // }else{
    //  return MoAppBar.getAppBar("Reaction Test", context,color: Theme.of(context).primaryColor);
   // }
  }


  Widget getBody()
  {
    if(this.moState.start()){
      return widget.reactionTime.content.toWidget(context);
    }else if(this.moState.wait()){

      return playRestartResume();

    }else if(this.moState.loading()){

      return MoLoading(
        showTexts: ["3","2","1"],
        timerTime: 1,
        doThisWhenDone: startTheTest,
      );

    }
    return SizedBox();
  }


  void startTheTest(){
    //widget.reactionTime.content.updateContent();
    if(widget.reactionTime.content.isContentNumber()){
      widget.reactionTime.content.resetNumber();
    }
    widget.reactionTime.content.latestUpdateTime = DateTime.now();
    run = new Timer.periodic(widget.reactionTime.timer.getDuration(), update);
    setState(() {
      this.moState.setState(MoState.START);
    });
  }


  void refresh()
  {
    setState(() {

    });
  }


  Widget playRestartResume()
  {
    if(widget.reactionTime.content.reactionsTimes.isEmpty){
      if(widget.reactionTime.numberOfObjects.isZero()){
        widget.reactionTime.restart();
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.reactionTime.type.getInstructions(),
            new MoButton(
              paddingAll: 8.0,
              text: "Start",
              radius: 100,
              onTap: (){
                setState(() {
                  this.moState.setState(MoState.LOADING);
                });
              },
            )
          ],
        ),
      );
    }else{
      return Center(
        child: MoCard(
          cardRadius: MoCard.ROUND_REC_RADIUS,
          padding: MoPaddingVersions.universal(),
          childPadding: MoPaddingVersions.universal(),
          mainAxisSize: MainAxisSize.min,
          childColumn: <Widget>[
            Flexible( child:widget.reactionTime.content.showResults(context,refresh),),
            new MoButton(
              radius: 20.0,
              onTap: (){
                setState(() {
                  widget.reactionTime.restart();
                });

              },
              text: "Restart",
            ),
            getResumeButton()
          ],
        ),
      );
    }
  }

  Widget getResumeButton()
  {
    if(!widget.reactionTime.numberOfObjects.isZero()){
      return MoButton(
        radius: 20.0,
        onTap: (){
          setState(() {
            this.moState.setState(MoState.LOADING);
          });
        },
        text:"Resume"
      );
    }
    return SizedBox();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(run!=null){
      this.run.cancel();
    }
  }



}
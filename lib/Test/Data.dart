import 'package:moction/Json/Json.dart';
import 'package:moction/Test/Tools.dart';
import 'package:flutter/material.dart';
import 'package:moction/ReactionTime/ReactionTime.dart';
import 'package:moction/ReactionTime/Elapsed.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/MoWidgets/MoColor.dart';

class Data{


  String _data;
  String _title;
  String ogTitle;
  ReactionTime _reactionTime;

  dynamic dataSaved;


  Data(this._data,this._title);


  ReactionTime get reactionTime => _reactionTime;

  set reactionTime(ReactionTime value) {
    _reactionTime = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }



  Widget getReactionWidget(BuildContext context,VoidCallback refresh)
  {
    List<Widget> ws = this.reactionTime.content.getReactionTimesWidgets(context,refresh);
    if(ws.isEmpty){
      return SizedBox();
    }
    return MoCard(
      elevation: 10.0,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      childPadding: MoPadding(paddingAll: 8.0),
      cardRadius: MoCard.ROUND_REC_RADIUS,
      backgroundColor: MoColor.canvasColor,
      childColumn: ws,
    );
  }


  List<double> getResults()
  {
    return ElapsedFunctions.getAverageMilliSeconds(this.reactionTime.content.reactionsTimes);
  }

  toJson()
  {
    return {
      Tools.DATA : this.data,
      Tools.TITLE : this._title
    };
  }

  toClass(dynamic data)
  {
    this.dataSaved = data;
    this.data = data[Tools.DATA];
    this.title = data[Tools.TITLE];
    this.ogTitle = this.title;
    this.reactionTime = new ReactionTime(this.data);
  }

  toResult()
  {
    return {
        Tools.TITLE: Json.listElapsedJson(this.reactionTime.content.reactionsTimes),
    };
  }

  toClassFromResult(dynamic data){
    Map<dynamic,dynamic> map = data[Tools.TITLE];
    map.forEach((dynamic key,dynamic value){
      Elapsed elapsed = new Elapsed(new Duration(), "");
      elapsed.toClass(value);
      this.reactionTime.content.reactionsTimes.add(elapsed);
    });
  }

  restart()
  {
    this.toClass(this.dataSaved);
  }


  toWidget()
  {
    return Column(
      children: <Widget>[
        new Text("Title: " + this.title),
        new Text("Data: "+  this.data),
      ],
    );
  }


  toSearch()
  {
    return this.data.toLowerCase();
  }


}

class DataConstants{

  static const String RANDOM = "RANDOM";
  static const String EMPTY = "";

  //classes
  static const String CONTENT = "CONTENT";
  static const String NUMBER_OF_OBJECTS = "NOO";
  static const String TIMER = "TIMER";
  static const String TYPE = "TYPE";

  static const CLASSES = [CONTENT,NUMBER_OF_OBJECTS,TIMER,TYPE];

  ///CONTENT
  static const String COLOR = "COLOR";
  static const String NUMBERS = "NUMBERS";
  static const String MIX = "MIX";
  static const CONTENT_OPTIONS = [COLOR,NUMBERS,MIX,EMPTY];


  ///NUMBER_OF_OBJECTS
  static const NOO_OPTIONS = [EMPTY];

  ///TIMER
  static const String RANDOM_CHANGER = "RANDOM_CHANGER";
  static const String RANDOM_FIXED = "RANDOM_FIXED";
  static const TIMER_OPTIONS = [RANDOM_FIXED,RANDOM_CHANGER,EMPTY];

  ///TYPE
  static const String SIMPLE = "SIMPLE";
  static const String CHOICE = "CHOICE";
  static const TYPE_OPTIONS = [SIMPLE,CHOICE,EMPTY];




  static List<String> allPossibilities()
  {
    List<String> all = new List();
    for(int i = 0;i < CLASSES.length;i++){
      String type = CLASSES[i];
      List<String> operateOn;
      switch(type){
        case CONTENT:
          operateOn = CONTENT_OPTIONS;
          break;
        case NUMBER_OF_OBJECTS:
          operateOn = NOO_OPTIONS;
          break;
        case TIMER:
          operateOn = TIMER_OPTIONS;
          break;
        case TYPE:
          operateOn = TYPE_OPTIONS;
          break;
      }

      for(int j = 0;j<operateOn.length;j++){
        all.add(type +": " + operateOn[j]);
      }

    }

    return all;
  }

}
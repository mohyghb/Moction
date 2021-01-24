import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/Test/Range.dart';
import 'package:moction/Helpers.dart';
import 'package:flutter/material.dart';
import 'package:moction/Test/Tools.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/Test/MoData.dart';

class Score
{

  static const String LOGIC = "l";
  static const String INFO = "i";



  String _title;
  String ogTitle;
  Range _range;
  String id;
  String data;


  /// logics to do stuff based on other tools
  /// for all to add description to the range

  Map<String, String> logic;

  dynamic dataSaved;

  Score(this._title,this._range,this.data){
    this.id = Helpers.generateRandomId();
    this.logic = new Map();
  }

  ///
  /// extracts data from a meta-data string
  /// for this class
  extractData()
  {
    List<String> splitData = MoData.split(this.data, ["{","}"]);
    for(String sData in splitData){
      String firstLetter = sData.trim().substring(0,1);
      guideData(sData, firstLetter);
    }

  }

  /// guides the data to which place it should go based on the first letter
  guideData(String data,String firstLetter)
  {
    this.logic.putIfAbsent(firstLetter, ()=> data.substring(2));
  }

  Range get range => _range;

  set range(Range value) {
    _range = value;
  }


  String get title => _title;

  set title(String value) {
    _title = value;
  }

  toJson(){
    return {
      Helpers.NAME : this.title,
      Helpers.RANGE  : this.range.toJson(),
      Tools.DATA  : this.data
    };

  }

  toClass(dynamic data)
  {
    try{
      this.dataSaved = data;
      this.title = data[Helpers.NAME];
      this.ogTitle = this.title;

      this.range.toClass(data[Helpers.RANGE]);
      this.data = data[Tools.DATA];
      extractData();
    }catch(e){
      print("from score "+ e.toString());
    }

  }

  restart()
  {
    this.toClass(this.dataSaved);
  }

  toWidget()
  {
    return new Column(
      children: <Widget>[
        new Text("Score: "+  this.title),
        new Text("start: "+this.range.start),
        new Text("End: "+ this.range.end),
        new Text("Increment: "+this.range.increment),
        new Text("Data: " + MoNotNull.string(this.data)),
      ],
    );
  }

  /// shows grade information
  String gradeInfo()
  {
    String info = this.logic[INFO];
    return MoNotNull.string(info);
  }

  Widget getRangeWidget(VoidCallback refresh,Color themeColor,Color textColor,bool disabled)
  {
    List<String> range = this.range.list();

    return Container(
      height: 58,
      child: ListView.builder(
            shrinkWrap: true,
            //physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,

            itemCount: range.length,
            itemBuilder: (BuildContext context, int index){
              return new MoButton(
                text: range[index],
                splashColor: Colors.black,
                color: textColor,
                textColor: themeColor,
                radius: 100.0,
                onTap: (){
                  if(!disabled){
                    this.title = range[index];
                    refresh();
                  }
                },
              );
            }
        ),
    );
  }


  toSearch()
  {
    return this.title.toLowerCase() + " " + this.range.toSearch();
  }

  toResult()
  {
    return {
      Helpers.NAME : this.title
    };
  }

  toClassFromResult(dynamic data){
    this.title = data[Helpers.NAME];
  }


  String showTitle()
  {
    if(this.title.codeUnitAt(0)>=48 && this.title.codeUnitAt(0)<=57){
      return "Score: ${this.title}";
    }else{
      return this.title;
    }
  }


  double getScore()
  {
    if(this.title.codeUnitAt(0)>=48 && this.title.codeUnitAt(0)<=57){
      return double.parse(this.title);
    }else{
      return 0;
    }
  }



}
import 'package:moction/Helpers.dart';
import 'package:flutter/material.dart';

class Timer
{

  /// the time is stored in here as in milliseconds
  String _title;

  String ogTitle;


  String _hintTitle;

  String id;

  dynamic dataSaved;


  Timer(this._title){
    this.id = Helpers.generateRandomId();
  }



  double timeSec()
  {
    try{
       double d =  double.parse(this.title)/1000;
       print("Time that has been gotten "+d.toString());
       return d;
    }catch(e){
      return 0;
    }
  }

  double lengthCm()
  {
    try{
      double d =  double.parse(this.title);
      print("length that has been gotten "+d.toString());
      return d;
    }catch(e){
      return 0;
    }
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }


  String get hintTitle => _hintTitle;

  set hintTitle(String value) {
    _hintTitle = value;
  }


  String getRightTitle()
  {
    return (this.hintTitle==this.title)?"":this.title;
  }

  toJson(){
    return {
      Helpers.NAME : this.title,
    };

  }

  toClass(dynamic data)
  {
    dataSaved = data;
    this.title = data[Helpers.NAME];
    this.ogTitle = this.title;
    this._hintTitle = title;
  }

  toResult()
  {
    return this.toJson();
  }

  toClassFromResult(dynamic data){
    this.title = data[Helpers.NAME];
  }

  restart()
  {
    this.toClass(this.dataSaved);
  }


  toWidget()
  {
    return new Text("Timer: " + this.title,textAlign: TextAlign.center,);
  }


  toSearch()
  {
    return this.title.toLowerCase();
  }


}
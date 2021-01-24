import 'package:moction/Helpers.dart';
import 'package:flutter/material.dart';

class Checker
{

  String _title;
  String ogTitle;
  String _score;
  bool wasPressed;
  String id;

  dynamic data;

  Checker(this._title,this._score){
    this.wasPressed =false;
    this.id = Helpers.generateRandomId();
  }


  String get score => _score;

  set score(String value) {
    _score = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  toJson(){
    return {
      Helpers.NAME : this.title,
      Helpers.SCORE : this.score,
    };
  }

  toClass(dynamic data)
  {
    this.data = data;
    this.title = data[Helpers.NAME];
    this.ogTitle = this.title;
    this.score = data[Helpers.SCORE];
  }

   toResult()
  {
    return {
      Helpers.NAME: this.title,
      Helpers.WAS_PRESSED  : this.wasPressed
    };
  }

  toClassFromResult(dynamic data){
    this.title = data[Helpers.NAME];
    this.wasPressed = data[Helpers.WAS_PRESSED];
  }

  restart() {
    this.toClass(this.data);
    this.wasPressed = false;
  }

  toWidget()
  {
    return Column(
      children: <Widget>[
        new Text("Checker: "+  this.title),
        new Text("Score: "+ this.score)
      ],
    );
  }


  toSearch()
  {
    return this.title.toLowerCase() +  " "  + this.score;
  }



}
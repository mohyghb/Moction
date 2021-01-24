import 'package:moction/Helpers.dart';
import 'package:flutter/material.dart';

class Button
{
  ///all buttons when pressed, add their score to the score of the subtest
  ///and then disable all other buttons
  ///the user can only press one button per sub test


  String _title;
  String ogTitle;
  String _score;
  bool deleted;
  bool wasPressed;
  String id;

  dynamic data;

  Button(this._title,this._score){
    this.deleted = false;
    this.wasPressed = false;
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


  restart()
  {
    this.toClass(this.data);
    this.wasPressed = false;
    this.deleted = false;
  }


  toWidget()
  {
    return Column(
      children: <Widget>[
        new Text("Button: "+ this.title),
        new Text("Score: " + this.score)
      ],
    );
  }


  toSearch()
  {
    return this.title.toLowerCase() +  " " + this.score;
  }



}
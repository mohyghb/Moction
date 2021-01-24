import 'package:moction/MoWidgets/MoButton.dart';
import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoColor.dart';

class ChoiceButton{

  MoButton _button;
  String _content;
  String _name;

  bool isActive;

  /// content is one of:
  /// - color
  /// - number
  ///
  /// content means that when they see this content, they have to press the button with the name
  /// this.name
  ChoiceButton(String content,String name){
    this._content = content;
    this._name = name;
    this.isActive = true;
    this._button = new MoButton(
      text: name,
      color: Colors.black,
      textColor: Colors.white,
      radius: 100.0,
    );
  }

  Color getLabelColor()
  {
    Color c =  MoColor.darkColors[this.content];
    return c==null? Colors.black:c;
  }




  setOnTap(VoidCallback onTap)
  {
    this.button.onTap = onTap;
  }


  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  MoButton get button => _button;

  set button(MoButton value) {
    _button = value;
  }

  deactivate()
  {
    this.isActive = false;
  }

  activate()
  {
    this.isActive = true;
  }


  getOnTap()
  {
    return this.button.onTap;
  }

}
import 'package:moction/Helpers.dart';
import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoButton.dart';

class Range
{
  String _start;
  String _end;
  String _increment;




  Range(this._start,this._end,this._increment);

  String get increment => _increment;

  set increment(String value) {
    _increment = value;
  }

  String get end => _end;

  set end(String value) {
    _end = value;
  }

  String get start => _start;

  set start(String value) {
    _start = value;
  }

  List<String> list()
  {
    double s = double.parse(this.start);
    double e = double.parse(this.end);
    double inc = double.parse(this.increment);
    List<String> list = new List();
    for(double i = s;i<=e;i+=inc){
        list.add(i.toString());
    }
    return list;
  }




  toJson(){
    return {
      Helpers.START : this.start,
      Helpers.END  :this.end,
      Helpers.INCREMENT : this.increment
      //range json
    };

  }

  toClass(dynamic data)
  {
    this.start = data[Helpers.START];
    this.end = data[Helpers.END];
    this.increment = data[Helpers.INCREMENT];
  }


  String toSearch()
  {
    return this.start + " " + this.end + " " + this.increment;
  }

}
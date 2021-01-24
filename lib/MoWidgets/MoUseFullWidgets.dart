import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class MoUseFullWidgets{

  /// returns a loading widget at the center of the screen in
  /// the safe zone
  static Widget loading()
  {
    return new SafeArea(
        child: Center(
          child: new CircularProgressIndicator(),
        )
    );
  }


  static Widget centerText(String text,IconData icon,{TextStyle tStyle})
  {
    return new SafeArea(
        child: Center(
          child: new Row(
            children: <Widget>[
              Icon(icon),
              new Text(text,textAlign: TextAlign.center,style: MoNotNull.Dynamic(tStyle,returnThis: new TextStyle(
              )),)
            ],
          ),
        )
    );
  }

}
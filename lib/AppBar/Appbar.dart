import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';


class Appbar
{

  static AppBar getAppBar(String title,BuildContext context)
  {
    return new AppBar(
      elevation: 0.0,
      title: new Text(MoNotNull.string(title),style: TextStyle(fontFamily: 'QucikSandLight',fontWeight: FontWeight.bold),),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }






}
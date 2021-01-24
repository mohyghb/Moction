import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';


class MoAppBar
{

  static AppBar getAppBar(String title,BuildContext context,{Color color})
  {
    return new AppBar(
      elevation: 0.0,
      title: new Text(MoNotNull.string(title)),
      centerTitle: true,
      backgroundColor: MoNotNull.color(color,returnThis:Theme.of(context).primaryColor),
    );
  }






}
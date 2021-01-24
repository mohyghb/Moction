import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class MoDialog{

  static void showMoDialog
      (BuildContext context, {Widget title,
    Widget content,
    List<Widget> actions
      })
  {

    showDialog(

        context: context,
      builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            titlePadding: EdgeInsets.all(0.0),
            title: MoNotNull.widget(title),
            content: MoNotNull.widget(content),
            actions: MoNotNull.Dynamic(actions,returnThis: SizedBox()),


          );
      }
    );
  }

  static void showBottomSheet(BuildContext context,List<Widget> widgets)
  {
    showModalBottomSheet<void>(context: context,

        builder: (BuildContext cont) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets
          );
        });
  }


}
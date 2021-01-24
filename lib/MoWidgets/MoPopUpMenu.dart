import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class MoPopUpMenu extends StatefulWidget
{

  static const String STATUS = "Status";


  List<String> options;
  ValueChanged onSelect;

  String savedValue;
  String initialValue;

  Widget child;
  IconData iconData;
  Color iconColor;

  ThemeData themeData;
  Color backgroundColor;



  MoPopUpMenu({this.options,this.onSelect,this.savedValue, this.child,this.themeData,this.backgroundColor,this.iconColor}){
   this.initialValue = savedValue;
  }


  bool validate()
  {
    if(savedValue!=initialValue){
      print("true");
      return true;
    }
    print("false");
    backgroundColor = Colors.red;
    return false;
  }



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MoPopUpMenuState();
  }
}
class MoPopUpMenuState extends State<MoPopUpMenu>
{



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Theme(
      data: MoNotNull.theme(widget.themeData, context,returnThis: Theme.of(context)),
      child: new PopupMenuButton<String>(
            onSelected: widget.onSelect,
            icon: Icon(MoNotNull.Dynamic(widget.iconData,returnThis: Icons.more_vert),color: MoNotNull.color(widget.iconColor),),
//            child: NotNull.widget(widget.child,returnThis: new MoCard(
//              cardRadius: MoCard.NORMAL_PADDING,
//              paddingAll: MoCard.NORMAL_PADDING,
//              backgroundColor: NotNull.color(widget.backgroundColor,returnThis:Theme.of(context).primaryColor),
//              child: new Text(NotNull.string(widget.savedValue),textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
//            )),
            itemBuilder: (BuildContext context) {
              return widget.options.map((String m){
                return new PopupMenuItem<String>(
                  value: m,
                  child: new Text(m),
                );
              }).toList();
            }
      ),
    );
  }








}

class MoPopUpMenus{

  static MoPopUpMenu NORMAL(String title,List<String> options){
    MoPopUpMenu moPopUpMenu = new MoPopUpMenu(
      options: options,
      savedValue: title,
    );


    return moPopUpMenu;
  }

}
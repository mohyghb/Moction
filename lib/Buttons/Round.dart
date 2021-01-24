import 'package:flutter/material.dart';


class Round extends StatelessWidget
{
  String text;
  IconData iconData;
  VoidCallback onTap;
  double spaceBetweenTI;
  double radius;
  Color color;
  Color textColor;
  Color disabledColor;
  double elevation;
  double disabledElevation;

  double width;
  double height;


  Round({
    this.text,
    this.iconData,
    this.onTap,
    this.spaceBetweenTI,
    this.radius,
    this.color,
    this.textColor,
    this.disabledColor,
    this.elevation,
    this.disabledElevation,
    this.width,
    this.height

  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: this.onTap,
        child: new Container(
          width: getNotNullDouble(this.width),
          height: getNotNullDouble(this.height),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              getIcon(context),
              new SizedBox(width: getNotNullDouble(this.spaceBetweenTI)),
              getText(context),
            ],
          ),
          decoration: new BoxDecoration(
            color: getColor(context),
            shape: BoxShape.circle,
          ),
        )
    );
  }




  Widget getText(BuildContext context)
  {
    if(this.text!=null){
      return new Text(this.text,
          style: new TextStyle(
              color: getTextColor(context)));
    }
    else{
      return SizedBox();
    }
  }

  double getNotNullDouble(double d)
  {
    if(d==null){
      return 0;
    }
    else{
      return d;
    }
  }

  Widget getIcon(BuildContext context)
  {
    if(this.iconData!=null){
      return new Icon(iconData, color: getTextColor(context),);
    }
    else{
      return new SizedBox(width: 0,);
    }
  }


  Color getColor(BuildContext context)
  {
    if(this.color!=null){
      return this.color;
    }
    else{
      return Theme.of(context).primaryColor;
    }
  }


  Color getTextColor(BuildContext context)
  {
    if(this.textColor!=null){
      return this.textColor;
    }
    else{
      return Colors.black;
    }
  }

  Color getDisabledColor(BuildContext context)
  {
    if(this.disabledColor!=null){
      return this.disabledColor;
    }
    else{
      return Theme.of(context).disabledColor;
    }
  }

}
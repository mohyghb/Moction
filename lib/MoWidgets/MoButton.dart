import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoTexts.dart';

// ignore: must_be_immutable
class MoButton extends StatelessWidget
{

  static const double MIN_SIZE = 15;

  String text;
  IconData iconData;
  VoidCallback onTap;
  double spaceBetweenTI;
  double radius;

  Color color;
  Color textColor;
  Color disabledColor;
  Color splashColor;

  double elevation;
  double disabledElevation;



  // padding
  double paddingAll;
  double paddingLeft;
  double paddingRight;
  double paddingTop;
  double paddingBottom;

  double paddingWidths;
  double paddingHeights;

  double totalRightPadding;
  double totalLeftPadding;
  double totalTopPadding;
  double totalBottomPadding;


  double size;

  ThemeData themeData;

  Widget child;

  MoButton({
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
    this.paddingHeights,
    this.paddingWidths,
    this.paddingTop,
    this.paddingLeft,
    this.paddingRight,
    this.paddingAll,
    this.paddingBottom,
    this.size,
    this.themeData,
    this.splashColor,
    this.child
  }){
    double totalPadding = MoNotNull.Double(this.paddingAll);

    totalRightPadding = MoNotNull.Double(this.paddingRight) + totalPadding + MoNotNull.Double(this.paddingWidths);
    totalLeftPadding = MoNotNull.Double(this.paddingLeft) + totalPadding + MoNotNull.Double(this.paddingWidths);
    totalTopPadding = MoNotNull.Double(this.paddingTop) + totalPadding + MoNotNull.Double(this.paddingHeights);
    totalBottomPadding = MoNotNull.Double(this.paddingBottom) + totalPadding + MoNotNull.Double(this.paddingHeights);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return Padding(
        padding: EdgeInsets.only(left: totalLeftPadding,right: totalRightPadding,top: totalTopPadding,bottom: totalBottomPadding),
        child: MoCard(
          elevation: MoNotNull.Double(this.elevation),
          cardRadius: MoNotNull.Double(this.radius),
          backgroundColor: MoNotNull.color(this.color,returnThis:MoNotNull.theme(this.themeData, context).primaryColor),
          child: InkWell(
            splashColor: MoNotNull.color(this.splashColor),
            borderRadius: BorderRadius.circular(MoNotNull.Double(this.radius)),
            onTap: this.onTap,
            child: Padding(
              padding: EdgeInsets.all(MoNotNull.Double(size,returnThis: MIN_SIZE)),
              child: getChild(context),
            ),
          ),
        ),
    );

//    return Padding(
//      padding: EdgeInsets.only(left: totalLeftPadding,right: totalRightPadding,top: totalTopPadding,bottom: totalBottomPadding),
//      child: new RaisedButton(
//        elevation: NotNull.Double(this.elevation),
//        disabledElevation: NotNull.Double(this.disabledElevation),
//        disabledColor:  NotNull.color(this.disabledColor,returnThis: Theme.of(context).disabledColor),
//        shape: new RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(NotNull.Double(this.radius))),
//        color: NotNull.color(this.color,returnThis: Theme.of(context).primaryColor),
//            child: new Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              mainAxisSize: MainAxisSize.max,
//              children: <Widget>[
//              getIcon(context),
//              new SizedBox(width: NotNull.Double(this.spaceBetweenTI)),
//              getText(context)
//             ],
//          ),
//          onPressed: this.onTap),
//    );
  }


  Widget getChild(BuildContext context)
  {
    return MoNotNull.widget(this.child,returnThis: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        getIcon(context),
        SizedBox(width: MoNotNull.Double(this.spaceBetweenTI)),
        getText(context),
      ],
    ));
  }


  Widget getText(BuildContext context)
  {
    if(this.text!=null){
      return new Text(this.text,
          style: new TextStyle(
              color:  MoNotNull.color(this.textColor)));
    }
    else{
      return SizedBox();
    }
  }



  Widget getIcon(BuildContext context)
  {
    if(this.iconData!=null){
      return new Icon(iconData, color: MoNotNull.color(this.textColor),);
    }
    else{
      return new SizedBox(width: 0,);
    }
  }
  
  

}


class MoButtons
{

  static getDisabledOnTap(bool disabled,void onTap)
  {
    if(disabled){
      return null;
    }
    return onTap;
  }


  static Widget titleDescriptionButton(
      BuildContext context,
      Color backgroundColor,
      String title,
      String description,
      VoidCallback onTap,
  {
    double titleFont,
  }
      )
  {
    return MoCard(
      backgroundColor: backgroundColor,
      cardRadius: MoCard.ROUND_REC_RADIUS,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      // childPadding: MoPadding(paddingAll: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(MoCard.ROUND_REC_RADIUS),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                MoTexts.titleText(context, title, backgroundColor,fontSize: titleFont),
                new Text(description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



}
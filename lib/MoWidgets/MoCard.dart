import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoPadding.dart';

class MoCard extends StatelessWidget{


  static const double CIRCLE_RADIUS = 100.0;
  static const double RECTANGLE_RADIUS = 0.0;
  static const double ROUND_REC_RADIUS = 20.0;


  static const double MID_ELEVATION = 10.0;

  static const double NORMAL_PADDING = 8.0;


  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  MainAxisSize mainAxisSize;

  Color backgroundColor;
  double cardRadius;
  double elevation;

  Widget child;
  List<Widget> childColumn;
  List<Widget> childRow;


  MoPadding padding;
  MoPadding childPadding;

  MoCard({
    this.mainAxisSize,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.childRow,
    this.childColumn,
    this.child,
    this.backgroundColor,
    this.elevation,
    this.cardRadius,
    this.padding,
    this.childPadding,
  });


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Padding(
      padding: MoNotNull.Dynamic(this.padding,returnThis: MoPadding(paddingAll: 0.0)).getPadding(),
      child: new Card(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MoNotNull.Double(this.cardRadius))),
       elevation: MoNotNull.Double(this.elevation),
       color: MoNotNull.color(this.backgroundColor,returnThis: Theme.of(context).cardColor),
       child: Padding(
         padding: MoNotNull.Dynamic(this.childPadding,returnThis: MoPadding()).getPadding(),
         child: getChild(),
       )
      ),

    );
  }

   Widget getChild()
   {
     if(this.child!=null){
       return this.child;
     }else if(this.childColumn!=null){
       return new Column(
         mainAxisAlignment: MoNotNull.Dynamic(this.mainAxisAlignment,returnThis: MainAxisAlignment.start),
         crossAxisAlignment: MoNotNull.Dynamic(this.crossAxisAlignment,returnThis: CrossAxisAlignment.start),
         mainAxisSize: MoNotNull.Dynamic(this.mainAxisSize,returnThis: MainAxisSize.min),
         children: this.childColumn
       );
     }else if(this.childRow!=null){
       return new Row(
           mainAxisAlignment: MoNotNull.Dynamic(this.mainAxisAlignment,returnThis: MainAxisAlignment.start),
           crossAxisAlignment: MoNotNull.Dynamic(this.crossAxisAlignment,returnThis: CrossAxisAlignment.start),
           mainAxisSize: MoNotNull.Dynamic(this.mainAxisSize,returnThis: MainAxisSize.min),
           children: this.childRow
       );
     }
     return SizedBox();
   }





}
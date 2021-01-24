import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoColor.dart';

class MoText{
  /// to create  mo text
  /// later...
}


class MoTexts{
  /// pre defined text styles
  ///
  static const double SPACE = 10.0;
  static const double FONT_SIZE = 15;
  static const double TITLE_FONT_SIZE = 40;


  static const String NAME = "Name: ";
  static const String PHONE_NUMBER = "Phone Number: ";
  static const String EMAIL = "Email: ";
  static const String AGE = "Age: ";
  static const String DATE = "Date: ";
  static const String TIME = "Time: ";
  static const String RESULT = "Result: ";

  static Widget text(BuildContext context,{

    String text,
    IconData icon,
    TextStyle textStyle,
    TextAlign textAlign,
    Color color,
    MainAxisAlignment mainAxisAlignment,
    CrossAxisAlignment crossAxisAlignment,
    double space,
    String boldText,
    double fontSize,
    String fontFamily
  })
  {
    return new Row(
      mainAxisAlignment: MoNotNull.Dynamic(mainAxisAlignment,returnThis: MainAxisAlignment.start),
      crossAxisAlignment: MoNotNull.Dynamic(crossAxisAlignment,returnThis: CrossAxisAlignment.center),
      children: <Widget>[
        (icon==null)?SizedBox():Icon(icon,color: MoNotNull.color(color)),
        new SizedBox(width: MoNotNull.Double(space),),
        new Text(MoNotNull.string(boldText),
          textAlign: MoNotNull.Dynamic(textAlign,returnThis: TextAlign.start),
          style: TextStyle(
            fontFamily: fontFamily,
            color: MoNotNull.color(color),
            fontWeight: FontWeight.bold,
            fontSize: MoNotNull.Double(fontSize,returnThis: FONT_SIZE)

          ),),
         Expanded(
           child: new Text(
              MoNotNull.string(text),
              textAlign: MoNotNull.Dynamic(textAlign,returnThis: TextAlign.start),
              style: MoNotNull.Dynamic(textStyle,returnThis: TextStyle(
                fontFamily: fontFamily,
                color: MoNotNull.color(color),
                  fontSize: MoNotNull.Double(fontSize,returnThis: FONT_SIZE)
              )),
            ),
         ),
      ],
    );
  }


  static Widget simpleText(BuildContext context, String text, IconData icon,
      {
        double space,
        String bold,
        Color color,
        TextAlign align,
        MainAxisAlignment maa,
        CrossAxisAlignment caa
      }){
    return MoTexts.text(
      context,
      text: text,
      icon: icon,
      color: color,
      textAlign: align,
      mainAxisAlignment: maa,
      space: MoNotNull.Double(space,returnThis: SPACE),
      boldText: bold,
        crossAxisAlignment: caa
    );
  }



  static Widget titleText(BuildContext context, String text,Color backgroundColor,{
    double space,
    String bold,
    Color color,
    TextAlign align,
    double fontSize,
    MainAxisAlignment maa,
  })
  {
    return MoTexts.text(
        context,
        text: text,
        fontSize: MoNotNull.Double(fontSize,returnThis:TITLE_FONT_SIZE),
        color: MoColor.getAppropriateDesign(backgroundColor,MoColor.TEXT_COLOR),
        fontFamily: 'QuickSandRegular',
        textAlign: (align==null)?TextAlign.center:align,
        mainAxisAlignment: (maa==null)?MainAxisAlignment.center:maa,
        space: MoNotNull.Double(space,returnThis: SPACE),
        boldText: bold
    );
  }


  static Widget outLineText(Color background, Color outline,String text,
      {double offset,
        double font,
        double letterSpacing,
        TextAlign textAlign
      })
  {
    return new Text(text,
        textAlign: MoNotNull.Dynamic(textAlign,returnThis: TextAlign.center),
        style: TextStyle(
            color: background,
            fontSize: MoNotNull.Double(font,returnThis: 60),
        letterSpacing: MoNotNull.Double(letterSpacing,returnThis: 2),
        shadows: getShadows(MoNotNull.Double(offset,returnThis: 1.5),outline)));
  }


  static List<Shadow> getShadows(double offset,Color color)
  {
    return [
      Shadow( // bottomLeft
          offset: Offset(-offset, -offset),
          color: color
      ),
      Shadow( // bottomRight
          offset: Offset(offset, -offset),
          color: color
      ),
      Shadow( // topRight
          offset: Offset(offset, offset),
          color: color
      ),
      Shadow( // topLeft
          offset: Offset(-offset, offset),
          color: color
      ),
    ];
  }



  static TextSpan easyTextSpan(String text,{Color color, bool isBold,double fontSize})
  {
    return TextSpan(
      text: text,
      style: TextStyle(
          color: MoNotNull.color(color),
          fontWeight: MoNotNull.boolean(isBold)?FontWeight.bold:FontWeight.normal,
        fontSize: MoNotNull.Double(fontSize,returnThis: 12)
      )
    );
  }


}


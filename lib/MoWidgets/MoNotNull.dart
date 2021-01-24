import 'package:flutter/material.dart';

class MoNotNull
{


  static const String NULL_STRING = "";
  static const Color NULL_COLOR = Colors.white;
  static const double NULL_DOUBLE = 0;
  static const bool NULL_BOOLEAN = false;
  static const int NULL_INTEGER = 0;
  static const Widget NULL_WIDGET = SizedBox();


  /// takes string returns the string if not null
  /// return NULL_STRING if null

  static String string(String text,{String returnThis})
  {
    if(text == null){
      if(returnThis!=null){
        return returnThis;
      }
      return NULL_STRING;
    }else{
      return text;
    }
  }


  /// takes color returns the color if not null
  /// return NULL_COLOR if null

  static Color color(Color color,{Color returnThis})
  {
    if(color == null){
      if(returnThis!=null){
        return returnThis;
      }
      return NULL_COLOR;
    }else{
      return color;
    }
  }



  /// takes double returns the double if not null
  /// return NULL_DOUBLE if null

  static double Double(double number,{double returnThis})
  {
    if(number == null){
      if(returnThis!=null){
        return returnThis;
      }
      return NULL_DOUBLE;
    }else{
      return number;
    }
  }


  /// takes int returns the int if not null
  /// return NULL_INT if null

  static int integer(int number,{int returnThis})
  {
    if(number == null){
      if(returnThis!=null){
        return returnThis;
      }
      return NULL_INTEGER;
    }else{
      return number;
    }
  }


  /// takes boolean returns the boolean if not null
  /// return NULL_BOOLEAN if null

  static bool boolean(bool boolean,{bool returnThis})
  {
    if(boolean == null){
      if(returnThis!=null){
        return returnThis;
      }
      return NULL_BOOLEAN;
    }else{
      return boolean;
    }
  }


  /// takes widget returns the widget if not null
  /// return NULL_WIDGET if null

  static Widget widget(Widget widget,{Widget returnThis})
  {
    if(widget == null){
      if(returnThis!=null){
        return returnThis;
      }
      return NULL_WIDGET;
    }else{
      return widget;
    }
  }



  /// takes themeData returns the themeData if not null
  /// return returnThis if not null
  /// return THEME.OF(CONTEXT) if null

  static ThemeData theme(ThemeData themeData,BuildContext context,{ThemeData returnThis})
  {
    if(themeData == null){
      if(returnThis!=null){
        return returnThis;
      }
      return Theme.of(context);
    }else{
      return themeData;
    }
  }



  static dynamic Dynamic(dynamic dynam,{dynamic returnThis})
  {
    if(dynam == null){
      if(returnThis!=null){
        return returnThis;
      }
      return null;
    }else{
      return dynam;
    }
  }



}

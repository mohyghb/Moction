import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoRandom.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class MoColor{


  static const Color canvasColor = const Color(0xfff2f2f2);
  static const Color objectsOnCanvas = Colors.black;



  static const int BRIGHTNESS = 1;
  static const int TEXT_COLOR= 2;
  static const int TEXT_COLOR_AND_BRIGHTNESS = 3;


  static const List<double> OPACITY = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];

  static const String BLUE = "BLUE";
  static const String RED = "RED";
  static const String INDIGO = "INDIGO";
  static const String ORANGE = "ORANGE";
  static const String PINK = "PINK";
  static const String GREEN = "GREEN";
  static const String TEAL = "TEAL";
  static const String DEEP_PURPLE = "DEEP_PURPLE";
  static const String DEEP_ORANGE = "DEEP_ORANGE";
  static const String BROWN = "BROWN";
  static const String CYAN = "CYAN";
  static const String PURPLE_ACCENT = "PURPLE_ACCENT";
  static const String YELLOW = "YELLOW";
  static const String GREY = "GREY";
  static const String PURPLE = "PURPLE";

  /// a list of colors that can handle a white text on them
  /// these colors do NOT have the right names
  /// These are only used for test purposes
  static const darkColors= {
    BLUE:              Colors.blue,
    RED:               Colors.red,
    PINK:              Colors.purpleAccent,
    GREEN:             Colors.green,
    PURPLE:            Colors.deepPurple,
    ORANGE:            Colors.deepOrange,
    BROWN:             Colors.brown,
    YELLOW:            Colors.yellow,
    GREY:              Colors.grey
  };




  /// returns a random color from the darkColors list
  static Color randomDarkColor({Color except})
  {
    return MoRandom.getRandomColor(except: except,colorsToChoose: darkColors.values.toList());
  }

  /// returns a random list from the darkColors list()
  /// where index = 0 is the name of the color
  ///  index = 1 is the color
  static List<dynamic> randomDarkColorMap({String except,Color exceptColor})
  {

    String nDarkColor = MoRandom.getRandomDynamic(darkColors.keys.toList(),except: except);
    Color  rDarkColor = darkColors[nDarkColor];
    if(exceptColor!=null){
      while(rDarkColor == exceptColor){
        nDarkColor = MoRandom.getRandomDynamic(darkColors.keys.toList(),except: except);
        rDarkColor = darkColors[nDarkColor];
      }
    }

    return [nDarkColor,rDarkColor];
  }


  static Color getRandomPrimaryColor({Color except})
  {
    return MoRandom.getRandomColor(except: except,colorsToChoose: Colors.primaries);
  }



  /// if the backgroundColor is bright
  /// it returns black, white otherwise
  static getAppropriateDesign(Color backgroundColor, int mode)
  {
    if( backgroundColor == Colors.yellow ||
        backgroundColor == Colors.amber ||
        backgroundColor == Colors.cyanAccent||
        backgroundColor == Colors.yellowAccent||
        backgroundColor == Colors.amberAccent||
        backgroundColor == Colors.white||
        backgroundColor == Colors.lime||
        backgroundColor == Colors.limeAccent||
        backgroundColor == MoColor.canvasColor
      )
    {
      return decide(true,mode);
    }

    return decide(false,mode);
  }


  static dynamic decide(bool returnBlack,int mode)
  {
    switch(mode){
      case BRIGHTNESS:
        return returnBlack?Brightness.light:Brightness.dark;
      case TEXT_COLOR:
        return returnBlack?Colors.black:Colors.white;
      case TEXT_COLOR_AND_BRIGHTNESS:
        return returnBlack?[Colors.black,Brightness.light]:[Colors.white,Brightness.dark];
    }
  }





  /// takes a string 'title' in and
  /// produces a color based on that
  /// based on the string.length
  static Color getColorBasedText(List<Color> colors,String text)
  {
    int len = text.length;
    int colorsLen = colors.length;
    if(len>=colors.length){
      while(len>=colorsLen){
        len-=colorsLen;
      }
    }
    return colors[len];
  }


  /// returns a random opacity from the above list
  static double getRandomOpacity({double except})
  {
    double newOpacity = MoRandom.getRandomDynamic(OPACITY,except: except);
    return newOpacity;
  }





}
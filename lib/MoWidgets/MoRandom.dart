import 'dart:math';

import 'package:flutter/material.dart';
class MoRandom{

  /// a class dedicated for getting random things from it
  ///

  static Random random = new Random();



  static Color getRandomColor({List<Color> colorsToChoose,Color except})
  {
    if(except!=null){
      if(colorsToChoose!=null){
        Color newColor = colorsToChoose[random.nextInt(colorsToChoose.length-1)];
        while(newColor == except){
          newColor = colorsToChoose[random.nextInt(colorsToChoose.length-1)];
        }
        return newColor;
      }else{
        Color newColor = Colors.primaries[random.nextInt(Colors.primaries.length-1)];
        while(newColor == except){
          newColor = Colors.primaries[random.nextInt(Colors.primaries.length-1)];
        }
        return newColor;

      }
    }
    if(colorsToChoose!=null){
      return colorsToChoose[random.nextInt(colorsToChoose.length-1)];
    }
    return Colors.primaries[random.nextInt(Colors.primaries.length-1)];
  }


  static dynamic getRandomDynamic(List<dynamic> chooseFrom,{dynamic except})
  {
    if(except!=null){
        dynamic newDynamic = chooseFrom[random.nextInt(chooseFrom.length-1)];
        while(newDynamic == except){
          newDynamic = chooseFrom[random.nextInt(chooseFrom.length-1)];
        }
        return newDynamic;
    }
    return chooseFrom[random.nextInt(chooseFrom.length-1)];
  }







}
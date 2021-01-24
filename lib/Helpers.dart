
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class Helpers{



  //Random object
  static Random random = new Random();

  //List of available times in String


  //on-result data


  static const Color TEXT_COLOR = Colors.white;


  static const String DATE = "Dates";

  //constant fields
  //Strings
  static const String ID = "Id";
  static const String NAME = "Name";
  static const String LAST_NAME = "LastName";
  static const String PHONE_NUMBER = "PhoneNumber";
  static const String UID = "uid";
  static const String DELETED = "Deleted";
  static const String NOTIFICATION_TOKEN = "NotificationToken";


  //database references
  static const String BOSS = "Boss";
  static const String SWITCH = "Switch";
  static const String NEWS = "News";
  static const String BLOCKED_NUMBERS = "BlockedNumbers";


  static const String DATE_TIME = "DateTime";
  static const String DESCRIPTION = "Description";
  static const String TIME_IT_TAKES = "Time It Takes";
  static const String PRICE = "Price";
  static const String NOT_PROVIDED = "NotProvided";
  static const String INDEX = "Index";
  static const String STATUS = "STATUS";


  static const String HAS_NOTES  = "hasNote";
  static const String SUBS = "subs";
  static const String TOOL = "Tool";
  static const String SCORE = "Score";
  static const String TYPE = "Type";
  static const String START = "Start";
  static const String END = "End";
  static const String INCREMENT = "Increment";
  static const String RANGE = "Range";
  static const String LOGIC = "Logic";

  static const String WAS_PRESSED = "Was_Pressed";





  static const String HAS_IMAGE = "hasImage";
  static const String URL = "url";

  static const String CHOOSE_HAIR_JOB_TYPE = "Choose Hair Job";

      //genders
  static const String GENDER = "GENDER";
  static const String MALE = "Male";
  static const String FEMALE = "Female";
  static const String NOT_SPECIFIED = "NA";
  static const String BOTH = "Both";
  static const String CHOOSE_GENDER = "Choose Gender";

  //list of genders
  static const List<String> GENDERS = [Helpers.MALE,Helpers.FEMALE,Helpers.BOTH,Helpers.NOT_SPECIFIED];


  //week days
  static const String MONDAY = "Monday";
  static const String TUESDAY = "Tuesday";
  static const String WEDNESDAY = "Wednesday";
  static const String THURSDAY = "Thursday";
  static const String FRIDAY = "Friday";
  static const String SATURDAY = "Saturday";
  static const String SUNDAY = "Sunday";

  static const String SELECT_A_DATE = "Select a date";

  //list of weekdays
  static var weekdays = [MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY];


  //Doubles for size fonts

  static const double SIZE_VARIABLE = 4;
  static const double FONT_SIZE = 16;
  static const double TITLE_FONT_SIZE = FONT_SIZE + SIZE_VARIABLE;
  static const double DESCRIPTION_FONT_SIZE = FONT_SIZE - SIZE_VARIABLE;



  //Error Codes
  static const String NAME_ERROR_EMPTY = "The name can not be empty";
  static const String PRICE_ERROR_EMPTY = "The price can not be empty";
  static const String TIME_ERROR_EMPTY = "The time can not be empty";
  static const String GENDER_ERROR_EMPTY = "Please choose a gender";
  static const String NEED_INTERNET = "Please Connect to internet to verify";
  static const String DESCRIPTION_ERROR_EMPTY = "Description of a news can not be empty";




  //day refrences
  static const String IS_OPEN =  "IsOpen";
  static const String APPOINTMENTS = "Appointments";
  static const String WORKING_HOURS = "WorkingHours";



  //widgets
  static const Widget EMPTY_BOX = SizedBox(height: 0.0, width: 0.0);



  //hero animation tags
  static const String FAB_TAG_HERO = "FAB_TAG_HERO";
  static const String CHOOSE_USER_TAG_HERO = "CHOOSE_USER_TAG_HERO";
  static const String BACK_TAG_HERO = "BACK_TAG_HERO";



  //communication
  static const String SUCCESSFUL_DELETE = "Appointment was successfully deleted!";
  static const String FAILED_DELETE = "Sorry we could not delete the appointment."
      " Make sure you are connected to internet.";

  //Text of Widgets
  static const String CREATE = "Create";
  static const String EDIT = "Edit";



  //Time
  static const String AM = "am";
  static const String PM = "pm";
  static const double ROUND_LIMIT = 15.0;
  static const String START_TIME = "startTime";
  static const String END_TIME = "endTime";



  //appointments
  static const String NO_MORE_APPOINTMENT = "Sorry we are full!";
  static const int MAX_SIZE_APPOINTMENTS = 20000;


  //states
  static const int LOADING_STATE = 39402111;
  static const int FAILED_STATE  = -912481;
  static const int SUCCESSFUL_STATE = 912481;



  static const String RESERVED_APPOINTMENTS = "Reserved Appointments";
  static const String DAY_SETTINGS = "Day Setting";
  static const List<String> BOSS_SETTINGS = [Helpers.RESERVED_APPOINTMENTS,Helpers.DAY_SETTINGS];



  //Widget Functions
  static void getSnackBar(String text,BuildContext context)
  {
    Scaffold.of(context).showSnackBar(
        new SnackBar(
            content: new Text(
              text,
              textAlign: TextAlign.center,
            )));
  }





  //Helper Functions

  //Generate Random Id based on the given info
  static String generateRandomId()
  {
    int randomId = random.nextInt(1000000000);
    int randomId1 = random.nextInt(1000000000);
    int randomId2 = random.nextInt(1000000000);

    String idToString = randomId.toString()+randomId1.toString()+randomId2.toString();
    return idToString;
  }


  //get the hair jobs from the database




  //produce the numbers of the string only am and pm matters
//  static int getNumbers(String str)
//  {
//    String numbers = "";
//    var unicodes = str.codeUnits.toList();
//    for(int i = 0; i<str.length; i++){
//      if(isNumber(unicodes[i])){
//        numbers+=str.substring(i,i+1);
//      }
//    }
//
//    if(str==(PM)){
//      return 1200 + int.parse(numbers);
//    }else{
//      return int.parse(numbers);
//    }
//  }

  //returns true if the given char is a number
  static bool isNumber(var a)
  {
    return (a>=48&&a<=57);
  }






  //get and set the appointments of the user


  //if the given string has length>10 return a substring of length 10 + ...
  static String cut10(String s)
  {
    return cutN(s,10);
  }


  static String cutN(String s, int n)
  {
    if(s.length>n){
      return s.substring(0,n) + "...";
    }
    return s;
  }


  // takes a phone number and makes it fancier like 6053294111 -> 605-329-4111

  static String makeFancy(String pn)
  {
    if(pn.length==10){
      return pn.substring(0,3) + "-" + pn.substring(3,6) + "-" + pn.substring(6);
    }
    return pn;
  }




  static Widget makeText(String text,double font,Color c,bool cen)
  {
    return new Text(
      text,
      textAlign: (cen)?TextAlign.center:TextAlign.start,
      style: TextStyle(
        color: c,
        fontSize: font
      ),
    );
  }


  static Widget loading()
  {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }


  static Widget getListTile(String text, IconData icon, {VoidCallback onTap})
  {
    return ListTile(
      leading: Icon(icon),
      title: new Text(text),
      onTap: onTap,
    );
  }


  static void showSnackBar(String text,bool error, BuildContext context)
  {
     Scaffold.of(context).showSnackBar(
         SnackBar(content: new Text(text,style: TextStyle(color: Colors.white),),backgroundColor: error?Colors.red:Colors.green,)
     );
  }












}
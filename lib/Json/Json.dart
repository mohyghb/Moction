import 'package:moction/Helpers.dart';
import 'package:moction/ReactionTime/Elapsed.dart';
import 'package:moction/Test/Test.dart';
import 'package:moction/Test/Tools.dart';
import 'package:moction/Test/Button.dart';
import 'package:moction/Test/Checker.dart';
import 'package:moction/Test/Timer.dart';
import 'package:moction/Test/Score.dart';
import 'package:moction/Test/SubTest.dart';
import 'package:moction/Test/Range.dart';
import 'package:moction/Test/Data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:flutter/material.dart';
import 'package:moction/Loaded.dart';

class Json {


  static const String JASON = "cs";
  static const int LIMIT = 1000;

  static Map<String, String> listJson_String(List<dynamic> list) {
    Map<String, String> map = new Map();
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        map.putIfAbsent(i.toString()+JASON, ()=> list[i]);
      }
    }
    return map;
  }

  static List<String> loadJson_String(dynamic data)
  {
    List<String> list = new List();
    if(data!=null){
      Map<dynamic,dynamic> map = data;
      if(map!=null){

          for(int i = 0; i<LIMIT;i++){
            var obj = map[i.toString() + JASON];
            if(obj == null){
              break;
            }else{
              list.add(obj);
            }
          }
//          map.forEach((dynamic key, dynamic value){
//            list.add(value);
//          });
      }
    }
    return list;
  }


//  static Map<String, Map> listJson(List<dynamic> list) {
//    Map<String, Map> map = new Map();
//    if (list != null) {
//      for (int i = 0; i < list.length; i++) {
//        map.putIfAbsent(i.toString(), () => list[i].toJson());
//      }
//    }
//    return map;
//  }



  static Map<String, Map> listElapsedJson(List<Elapsed> list) {
    Map<String, Map> map = new Map();
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        map.putIfAbsent(i.toString()+"cs", () => list[i].toJson());
      }
    }
    return map;
  }



  static Map<String, Map> listSubsJson(List<SubTest> list) {
    Map<String, Map> map = new Map();
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        map.putIfAbsent(list[i].subId, () => list[i].toJson());
      }
    }
    return map;
  }

  static List<SubTest> loadJson_SubTest(dynamic data,{bool loadTags,VoidCallback state})
  {
    List<SubTest> list = new List();
    if(data!=null){
      Map<dynamic,dynamic> map = data;
      if(map!=null){

        for(int i = 0; i<LIMIT;i++){
          String value = map[i.toString() + JASON];
          if(value == null){
            break;
          }else{
            SubTest subTest = new SubTest("");
            subTest.toClass(value,loadTags: loadTags,state: state);
            list.add(subTest);
          }
        }
//        map.forEach((dynamic key, dynamic value){
//          SubTest subTest = new SubTest("");
//          subTest.toClass(value,loadTags: loadTags,state: state);
//          list.add(subTest);
//        });
      }
    }
    return list;
  }


  static Future<List<SubTest>> loadJson_idSubTest(dynamic data,{bool loadTags,VoidCallback state,bool loadTools}) async
  {
    List<SubTest> list = new List();
    if(data!=null){
      Map<dynamic,dynamic> map = data;
      if(map!=null){

        int index = 0;

        for(int i = 0; i<LIMIT;i++){
          var value = map[i.toString() + JASON];
          if(value == null){
            break;
          }else{
            SubTest subTest = new SubTest("");
            subTest.index = index;
            subTest.idToClass(value,loadTags: loadTags,state: state,loadTools:loadTools).then((b){
              list.add(subTest);
            });
            index++;
          }
        }

//        map.forEach((dynamic key, dynamic value){
//
//        });
      }
    }
    return list;
  }


  static Future<List<Test>> loadJson_idTest(dynamic data,{bool loadTags,VoidCallback state}) async
  {
    List<Test> list = new List();
    if(data!=null){
      Map<dynamic,dynamic> map = data;
      if(map!=null){

        int index = 0;

        for(int i = 0; i<LIMIT;i++){
          String key = i.toString() + JASON;
          String value = map[key];
          if(value == null){
            break;
          }else{
            if(Loaded.tests !=null && Loaded.tests.containsKey(value)){
              list.add(Loaded.tests[value]);
            }else{
              Test test = new Test();
              test.id = value;
              Loaded.tests.putIfAbsent(value, ()=> test);
              test.loadBasic(state: state);
              //test.getSubsOfTest(loadTags: loadTags,state: state);
              list.add(test);
            }
            index++;
          }
        }
//        map.forEach((dynamic key, dynamic value){
//          if(Loaded.tests !=null && Loaded.tests.containsKey(value)){
//            list.add(Loaded.tests[value]);
//          }else{
//            Test test = new Test();
//            test.id = value;
//            Loaded.tests.putIfAbsent(value, ()=> test);
//            test.loadBasic(state: state);
//            //test.getSubsOfTest(loadTags: loadTags,state: state);
//            list.add(test);
//          }
//          index++;
//
//        });
      }
    }
    return list;
  }



//  map.forEach((dynamic k, dynamic v){
//  Test t = new Test();
//  t.toClass(v,type);
//  lot.add(t);
//  });

//  static List<dynamic> jsonToClassMap(dynamic map) {
//    List<dynamic> jsonList = new List<dynamic>();
//    Map<dynamic, dynamic> hashMap = new Map<dynamic, dynamic>.from(map);
//    if(hashMap!=null){
//      hashMap.forEach((dynamic k, dynamic value) {
//        try {
//          dynamic d;
//          String type = value[Helpers.TYPE];
//          switch (type) {
//            case Tools.TIMER:
//              var a = new Timer("");
//              d = new Tools(type, a);
//              break;
//            case Tools.SCORE:
//              var a = new Score("", new Range("", "", ""));
//              d = new Tools(type, a);
//              break;
//            case Tools.BUTTON:
//              var a = new Button("", "");
//              d = new Tools(type, a);
//              break;
//            case Tools.CHECKER:
//              var a = new Checker("", "");
//              d = new Tools(type, a);
//              break;
//            case Tools.DATA:
//              var a = new Data("");
//              d = new Tools(type, a);
//              break;
//            default:
//              d = new SubTest("");
//              break;
//          }
//
//          d.toClass(value);
//          jsonList.add(d);
//        } catch (e) {
//
//        }
//      });
//
//    }
//
//
//
//    return jsonList;
//  }


  static List<dynamic> jsonToClassList_ToolsEdition(dynamic map)
  {
    List<dynamic> jsonList = new List<dynamic>();
    for(int i = 0;i<Helpers.MAX_SIZE_APPOINTMENTS;i++){
      try{
        dynamic value = map[i];
        if(value!=null){
          dynamic d;
          String type = value[Helpers.TYPE];
          switch(type){
            case Tools.TIMER:
              var a = new Timer("");
              d = new Tools(type, a);
              break;
            case Tools.SCORE:
              var a = new Score("",new Range("", "", ""),"");
              d = new Tools(type, a);
              break;
            case Tools.BUTTON:
              var a = new Button("","");
              d = new Tools(type, a);
              break;
            case Tools.CHECKER:
              var a = new Checker("","");
              d = new Tools(type, a);
              break;
            case Tools.DATA:
              var a = new Data("","");
              d = new Tools(type, a);
              break;
            default:
              d = new SubTest("");
              break;
          }

          d.toClass(value);
          jsonList.add(d);
        }
        else{
          break;
        }
      }catch(e){
        break;
      }
    }
    return jsonList;
  }


  static List<dynamic> moJsonToClass (dynamic map)
  {

  }


}


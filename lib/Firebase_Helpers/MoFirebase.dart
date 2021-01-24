import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:moction/Loaded.dart';
import 'package:moction/Test/Test.dart';
import 'package:flutter/material.dart';
import 'package:moction/Test/Program.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';


class MoFirebase{


  ///
  /// Main channel of the firebase database
  static const String MAIN_CHANNEL = "MAIN_CHANNEL";

  ///
  /// constants
  static const String SUCCESS = "SUCCESS";
  static const String FAILED = "FAILED";


  //DataBase Reference "TESTS"

  static DatabaseReference getTestSubsRef()
  {
    return FirebaseDatabase.instance.reference().child(Test.TESTS_SUBS);
  }
  static DatabaseReference getTestSubsRefWith(String ref)
  {
    return getTestSubsRef().child(ref);
  }



  //DataBase Reference "REGISTER_KEYS"
  static const String RKEYS = "RKEYS";
  static DatabaseReference getRKeysRef()
  {
    return FirebaseDatabase.instance.reference().child(RKEYS);
  }
  static DatabaseReference getRKEYSRefWith(String ref)
  {
    return getRKeysRef().child(ref);
  }


  /// need to store the description id and the name of the test in another
  /// node so that the database wont load everything all at once
  /// so storing the test's des and name and id in another node as well
  /// this is the node:

  static DatabaseReference getTestsBasicRef()
  {
    return FirebaseDatabase.instance.reference().child(Test.TESTS_BASIC);
  }
  static DatabaseReference getTestsBasicRefWith(String ref)
  {
    return getTestsBasicRef().child(ref);
  }









  static DatabaseReference getProgramBasicRef()
  {
    return FirebaseDatabase.instance.reference().child(Program.PROGRAM_BASIC);
  }


  ///takes a database refrence and a json value and sets it
  ///if there is a connection

  static set(DatabaseReference ref,dynamic json) async
  {
      ref.set(json);
  }


  /// DatabaseRef -> listOfTests
  /// produce a list of Tests items from the database ref
  static Future<Map<String, dynamic>> getTests(DatabaseReference ref, String type,{bool forceRefresh}) async
  {
    Map<String, Test> lot = new Map();
    await ref.once().then((DataSnapshot data){
      if(data.value!=null){
        Map<dynamic,dynamic> map = data.value;

        map.forEach((dynamic k, dynamic v){
          if(!Loaded.tests.containsKey(k)||MoNotNull.boolean(forceRefresh)){
            Test t = new Test();
            t.toClass(v,type);
            lot.putIfAbsent(k, ()=> t);
          }else{
            lot.putIfAbsent(k, ()=> Loaded.tests[k]);
          }

        });
      }
    });
    return lot;
  }


  static Future<List<Program>> getPrograms(DatabaseReference ref, String type) async
  {
    List<Program> lop = new List();
    await ref.once().then((DataSnapshot data){
      if(data.value!=null){
        Map<dynamic,dynamic> map = data.value;

        map.forEach((dynamic k, dynamic v){
          Program p = new Program();
          p.toClass(v,type);
          lop.add(p);
        });
      }
    });
    return lop;
  }




  /// loads the test's subs
  static Future<Null> getSubsOfTest(Test test,{bool loadTags}) async{
    await getTestSubsRef().child(test.id).once().then((DataSnapshot data){
      if(data.value!=null){
        test.toClass(data.value, Test.TESTS_SUBS,loadTags: loadTags);
      }
    });
  }





  static checkInternet() async
  {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }



  ///organizations
  static const ORGANIZATION = "ORGANIZATIONS";

  /// to store everything inside there except the PATIENTS


  static DatabaseReference getOrganizations()
  {
    return FirebaseDatabase.instance.reference().child(ORGANIZATION);
  }
  static DatabaseReference getOrganizationsWith(String ref)
  {
    return getOrganizations().child(ref);
  }







}
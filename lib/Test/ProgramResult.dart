import 'package:flutter/material.dart';
import 'package:moction/Loaded.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Show/ShowAProgram.dart';
import 'package:moction/Test/Program.dart';
import 'package:moction/Test/Result.dart';
import 'package:firebase_database/firebase_database.dart';

class ProgramResult{


  List<Result> testResults;
  Program program;

  String date;
  String result;

  static const String BASIC = "Basic";
  static const String DETAILED = "Detailed";
  static const String MAP = "Map";



  ProgramResult(){
    this.testResults = new List();
  }

  String getDate()
  {
    return this.date.split("T")[0];
  }

  String getTime()
  {
    return this.date.split("T")[1];
  }





  toJson(String mode)
  {
    switch(mode)
    {
      case BASIC:
        return getBasicJson();
        break;
      case DETAILED:
        return getDetailedJson();
        break;
      case MAP:
        return this.program.getValues();
        break;
    }
  }


  getBasicJson()
  {
    return{
      Patient.DATE : this.date,
      Result.RESULTS : this.result
    };
  }


  getDetailedJson()
  {
    Map<dynamic,dynamic> map = new Map();
    for(Result result in this.testResults){
      map[result.testId] = result.toJson(Result.DETAILED_RESULTS);
    }
    return map;
  }

  toClass(dynamic data, String mode)
  {
    switch(mode){
      case BASIC:
        this.date = data[Patient.DATE];
        this.result = data[Result.RESULTS];
        break;
      case DETAILED:
        print(data);
        break;
      case MAP:
        print("to class map from program result");
        break;
    }
  }



  String getId()
  {
    return this.date
        .replaceAll(".", "")
        .replaceAll("T", "")
        .replaceAll("-", "")
        .replaceAll(":", "")
    ;
  }


  toWidget(BuildContext context,String mode)
  {

    switch(mode)
    {
      case BASIC:
        List<String> dateTime = this.parseDateTime();
        return MoCard(
          cardRadius: MoCard.ROUND_REC_RADIUS,
          padding: MoPaddingVersions.universal(),
          childPadding: MoPadding(
              paddingAll: 16.0
          ),
          backgroundColor: Theme.of(context).primaryColor,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          child:  InkWell(
            borderRadius: BorderRadius.circular(MoCard.ROUND_REC_RADIUS),
            onTap: ()=> this.onTap(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                children: <Widget>[
                  MoTexts.simpleText(context,dateTime[0],Icons.date_range,bold: MoTexts.DATE),
                  MoTexts.simpleText(context,dateTime[1],Icons.timelapse,bold: MoTexts.TIME),
                  MoTexts.simpleText(context,this.result,Icons.reorder,bold: MoTexts.RESULT),
                ],
              ),
            ),
          ),
        );
        break;
    }
  }


  onTap(BuildContext context)
  {
    ShowAProgram.program = Loaded.currentProgram;
    ShowAProgram.result = this;
    Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowAProgram(

    ))));
  }


  loadTestsForProgram(VoidCallback refresh) async
  {
    await FirebaseDatabase.instance.reference()
          .child(Patient.PATIENT_PROGRAM_SUBS)
          .child(Patient.currentPatient.id)
          .child(Loaded.currentProgram.id)
          .child(this.getId()).once().then((snap){
            Map<dynamic,dynamic> map = snap.value;
            map.forEach((dynamic key,dynamic value){
              Loaded.tests[key].mapOfSavedItems = value;
            });
        refresh();
      });
  }


  loadSavedValuesForTests(VoidCallback refresh) async
  {
    await FirebaseDatabase.instance.reference()
        .child(Patient.PATIENT_PROGRAM_MAPPED)
        .child(Patient.currentPatient.id)
        .child(Loaded.currentProgram.id)
        .child(this.getId()).once().then((snap){
          if(snap!=null){
            Map<dynamic,dynamic> map = snap.value;
            //   print("this is the saved map: " + map.cast<String,double>().toString());
            map.forEach((dynamic key,dynamic value){

              ShowAProgram.program.mapOfSavedValues.putIfAbsent(key, ()=> value.toDouble());
            });
            refresh();
          }
    });
  }


  List<String> parseDateTime()
  {
    return this.date.split("T");
  }


  saveProgramResult(String mode, Patient patient, String modeToSave)
  {
    FirebaseDatabase.instance.reference()
        .child(modeToSave)
        .child(Patient.currentPatient.id)
        .child(this.program.id)
        .child(this.getId())
        .set(this.toJson(mode));
  }








}
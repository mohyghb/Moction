import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/MoWidgets/MoPdf.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/Loaded.dart';
import 'package:moction/Show/ShowATest.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Test/Test.dart';

import '../Helpers.dart';

class Result{


  static const String RESULTS = "RESULTS";
  static const String DATE = "DATE";

  static const int NORMAL_RESULTS = 1;
  static const int DETAILED_RESULTS = 2;

  String _result;

  /// date time is the id of this test without a dot;
  String _dateTime;


  Map<String,dynamic> _mapOfResults;

  Map<dynamic,dynamic> mapOfSavedItemsSubs;

  Map<String,double> mapOfGraphing;

  String testId;
  Test test;

  Result();


  String get result => _result;

  set result(String value) {
    _result = value;
  }

  toJson(int mode)
  {
    switch(mode){
      case NORMAL_RESULTS:
        return {
          RESULTS: this._result,
          DATE :  this._dateTime
        };
        break;
      case DETAILED_RESULTS:
        return this._mapOfResults;
        break;
    }
  }

  toClass(dynamic data,int mode)
  {
    switch(mode){
      case NORMAL_RESULTS:
        this.result = data[RESULTS];
        this.dateTime = data[DATE];
        break;
      case DETAILED_RESULTS:
        this.mapOfResults = data;
        break;
    }

  }


  List<String> parseDateTime()
  {
    return this.dateTime.split("T");
  }

  String getDate()
  {
    return this.dateTime.split("T")[0];
  }

  String getTime()
  {
    return this.dateTime.split("T")[1];
  }



  toWidget(BuildContext context,int mode)
  {

    switch(mode)
    {
      case NORMAL_RESULTS:
        List<String> dateTime = this.parseDateTime();
        return MoCard(
          cardRadius: MoCard.ROUND_REC_RADIUS,
          padding: MoPadding(
            paddingWidths: 8.0
          ),
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
              padding: const EdgeInsets.only(left:8.0,right:8.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MoTexts.simpleText(context,this.test.title,Icons.title,bold: "Test: "),
                  SizedBox(height:10.0),
                  MoTexts.simpleText(context,dateTime[0],Icons.date_range,bold: MoTexts.DATE),
                  SizedBox(height:10.0),
                  MoTexts.simpleText(context,dateTime[1],Icons.timelapse,bold: MoTexts.TIME),
                  SizedBox(height:10.0),

                  MoTexts.simpleText(
                      context,
                      this.result,
                      Icons.reorder,
                      bold: MoTexts.RESULT,
//                      caa: CrossAxisAlignment.center,
                    align: TextAlign.center,
                 //   maa: MainAxisAlignment.center,
                  ),
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
    openInAppViewer(context);
//    showModalBottomSheet<void>(context: context,
//
//        builder: (BuildContext cont) {
//          return new Column(
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              Helpers.getListTile("Open pdf", Icons.picture_as_pdf,onTap: (){
//                openPdf(context);
//              })
//            ],
//          );
//        });
  }


  openPdf(BuildContext context) async
  {
    await this.loadSubsResults(null,onlyLoad: true);
    await Loaded.currentTest.download();
    Loaded.currentTest.mapOfSavedItems = this.mapOfSavedItemsSubs;
    Loaded.currentTest.startRegeneration();
    MoPdf.patientName = "random";
    MoPdf.nameOfPdf = this.dateTime;
    MoPdf.nameOfTheTestOrProgram = Loaded.currentTest.title;
    MoPdf.createPdfTest(Loaded.currentTest, context);
  }


  openInAppViewer(BuildContext context)
  {
    ShowATest.test = this.test;
    ShowATest.result = this;
    Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowATest(
    ))));
  }



  String get dateTime => _dateTime;

  set dateTime(String value) {
    _dateTime = value;
  }

  Map<String, dynamic> get mapOfResults => _mapOfResults;

  set mapOfResults(Map<String, dynamic> value) {
    _mapOfResults = value;
  }

  String getId()
  {
    return this.dateTime
        .replaceAll(".", "")
        .replaceAll("T", "")
        .replaceAll("-", "")
        .replaceAll(":", "")
    ;
  }


  loadSubsResults(VoidCallback refresh,{bool onlyLoad}) async
  {
    if(this.mapOfSavedItemsSubs!=null){
      if(!MoNotNull.boolean(onlyLoad)){
        ShowATest.test.mapOfSavedItems = this.mapOfSavedItemsSubs;
        // print("result was loaded already");
        if(refresh!=null){
          refresh();
        }
      }
    }else{
      await FirebaseDatabase.instance.reference()
          .child(Patient.PATIENT_TESTS_SUBS)
          .child(Patient.currentPatient.id)
          .child(this.test.id)
          .child(this.getId()).once().then((snap){
            if(MoNotNull.boolean(onlyLoad)){
              this.mapOfSavedItemsSubs = snap.value;
            }else{
              this.mapOfSavedItemsSubs = snap.value;
              ShowATest.test.mapOfSavedItems = this.mapOfSavedItemsSubs;
              if(refresh!=null){
                refresh();
              }
            }

      });
    }
  }


  loadMappedResults(VoidCallback refresh) async
  {
    if(this.mapOfGraphing!=null){

      // print("result was loaded already");
      refresh();
    }else{
      await FirebaseDatabase.instance.reference()
          .child(Patient.PATIENT_TESTS_MAPPED)
          .child(Patient.currentPatient.id)
          .child(this.test.id)
          .child(this.getId()).once().then((snap){
        this.mapOfGraphing = snap.value;
        print(this.mapOfGraphing);
        refresh();
      });
    }
  }









}
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoId.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/Show/ShowPrograms.dart';
import 'package:moction/Test/ProgramResult.dart';
import 'package:moction/Test/Test.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:moction/Helpers.dart';
import 'package:moction/Json/Json.dart';
import 'package:moction/Show/ShowAProgram.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/Make/MakeAProgram.dart';
import 'package:moction/Test/Logic.dart';
import 'package:moction/Show/ShowAllResultsOfAProgram.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Loaded.dart';


class Program
{


  static const int PROGRAM = 1943;
  static const String PROGRAM_BASIC = "PROGRAM_BASIC";
  static const String PROGRAM_SUBS = "PROGRAM_SUBS";

  static const String PROGRAM_NORMAL = "PROGRAM_NORMAL";


  static const List<String> TYPE_OF_TASK_ON_PROGRAM = [SAVE,TO_PDF];
  static const String SAVE = "Save";
  static const String TO_PDF = "To Pdf";

  static const String SHOW = "s";
  static const int START_PROGRAM = 1;
  static const int SHOW_SAVED_PROGRAM_RESULTS = 2;

  String _title;
  String _description;
  String _id;
  String _date;

  String _logic;
  String _actionLogic;
  String _commentLogic;

  List<Test> _tests;
  List<String> _listOfTestIds;

  Map<String,double> _mapOfSavedValues;

  List<Test> activeTests;


  List<ProgramResult> savedProgramResults;

  Program(){
    this.listOfTestIds = new List();
    this.mapOfSavedValues = new Map();
    this._actionLogic = "";
    this._commentLogic = "";
    this.activeTests = new List();
  }


  List<String> get listOfTestIds => _listOfTestIds;

  set listOfTestIds(List<String> value) {
    _listOfTestIds = value;
  }

  List<Test> get tests => _tests;

  set tests(List<Test> value) {
    _tests = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }


  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get logic => _logic;

  set logic(String value) {
    _logic = value;
  }


  String get id => _id;

  set id(String value) {
    _id = value;
  }


  Map<String, double> get mapOfSavedValues => _mapOfSavedValues;

  set mapOfSavedValues(Map<String, double> value) {
    _mapOfSavedValues = value;
  }

  toJson(String mode)
  {
    switch(mode)
    {
      case PROGRAM_BASIC:
        return {
          Helpers.NAME : this.title,
          Helpers.DESCRIPTION  : this.description,
          Helpers.DATE : this.date,
          Helpers.ID : this.id
        };
        break;
      case PROGRAM_SUBS:
        return{
          Helpers.SUBS : Json.listJson_String(this.listOfTestIds),
          Helpers.LOGIC: this.logic
        };
        break;
    }
  }

  toClass(dynamic data,String mode,{bool loadTags, bool loadTagsForSubTests,VoidCallback state})
  {
    switch(mode)
    {
      case PROGRAM_BASIC:
        this.title = data[Helpers.NAME];
        this.description = data[Helpers.DESCRIPTION];
        this.date = data[Helpers.DATE];
        this.id = data[Helpers.ID];
        break;
      case PROGRAM_SUBS:
        if(MoNotNull.boolean(loadTagsForSubTests)){
          /// load the tags of the sub only for editing purposes
          this.listOfTestIds = Json.loadJson_String(data[Helpers.SUBS]);
        }else{
          /// load the subs for a test
          Json.loadJson_idTest(data[Helpers.SUBS],loadTags: loadTags,state: state).then((List<Test> subs){
            this.tests = subs;
            if(state!=null){
              state();
            }
          });
        }
        _parseLogic(data[Helpers.LOGIC]);

        break;
    }
  }






  ///updates the program if it is already made
  ///or make a new one if there is none with this id
  update(String mode)
  {
    FirebaseDatabase.instance.reference().child(mode).child(this.id).set(this.toJson(mode));
  }


  /// adds a unique id to this program
  addId()
  {
    this._id = MoId.generateRandomId(unique: this.title);
  }


  /// download and load the subs
  load(String mode,{VoidCallback state})
  {
    FirebaseDatabase.instance.reference().child(mode).child(this.id).once().then((data){
      this.toClass(data.value, mode,state: state);
    });
  }


  /// get the logic and then
  /// parse the action logic
  /// and comment logic out of the main logic
  _parseLogic(String logic)
  {
    this.logic = logic;
    List<String> sep = logic.split("\n");
    for(String s in sep){
      if(s.startsWith("*")){
        this._actionLogic+=s.substring(1)+"\n";
      }else{
        this._commentLogic+=s+"\n";
      }
    }
    print(this._actionLogic);
    print(this._commentLogic);
  }



  ///get the widget for just showing the basic stuff
  Widget getBasicWidget(BuildContext context,int mode,{ VoidCallback closeSearch})
  {
    return MoButtons.titleDescriptionButton(
          context,
          Colors.black87,
          title,
          description,
              ()=>this.onTap(context, mode,closeSearch: closeSearch),
          titleFont: 30
    );
    return Hero(
      tag: this.id,
      child: MoCard(
        elevation: 2.0,
        backgroundColor: Colors.black,
        cardRadius: MoCard.ROUND_REC_RADIUS,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        child: InkWell(
          borderRadius: BorderRadius.circular(MoCard.ROUND_REC_RADIUS),
          onTap: ()=> onTap(context,mode,closeSearch: closeSearch),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  colTitleDescription(Colors.white),
                  edit(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  /// when the program is pressed
  onTap(BuildContext context,int mode,{VoidCallback closeSearch})
  {
    if(closeSearch!=null){
      closeSearch();
    }
    if(mode!=null){
      switch(mode)
      {
        case START_PROGRAM:
          ShowAProgram.program = this;
          Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowAProgram())));
          break;
        case SHOW_SAVED_PROGRAM_RESULTS:
          Loaded.currentProgram = this;
          /// show all results of a program
          ///
          Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowAllResultsOfAProgram(this))));
          break;
        default:
          break;
      }
    }

  }


  Widget edit(BuildContext context)
  {
    return MoButton(
      text: "Edit",
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (MakeAProgram(oldProgram: this,))));
      },
    );
  }


  /// show the title and description in a column
  Widget colTitleDescription(Color c)
  {
    return new Column(
      children: <Widget>[
        Helpers.makeText(this.title, Helpers.TITLE_FONT_SIZE, c, true),
        SizedBox(height: 7.0,),
        Helpers.makeText(this.description, Helpers.DESCRIPTION_FONT_SIZE, c, true),
      ],
    );
  }


  /// get tags so that it is searchable
  String toSearch()
  {
    return this.title.toLowerCase() + " " + this.description.toLowerCase() + " " + this.date.toLowerCase();
  }



  /// load the tests by their ids
  loadTestIds()
  {
    FirebaseDatabase.instance.reference().child(PROGRAM_SUBS).child(this.id).once().then((data){
      this.toClass(data.value, PROGRAM_SUBS,loadTagsForSubTests: true);
    });
  }


  ///
  /// get the available tests based on the action logic
  /// s.0 means show tests[0]
  ///
  List<Step> getSteps(BuildContext context,{bool loadTools})
  {
    List<Step> widgets = new List();
    List<String> sep = this._actionLogic.split("\n");
    Map<String,double> values = this.getValues();
    this.activeTests = new List();


    for(String logic in sep){
      Step object = _findLogic(context,values,logic,loadTools: loadTools);
      if(object!=null){
        widgets.add(object);
      }
    }



    return widgets;
  }


  /// performs action logic
  Step _findLogic(BuildContext context,Map<String,double> values, String logic,{bool loadTools})
  {
  //  print(logic);
    if(logic.contains("|")){
      List<String> los = MoLogic.logicForEveryLine(values, logic);

      return _performActionLogic(context,values,los.isEmpty?"":los.first,loadTools: loadTools);
    }else{
      return _performActionLogic(context,values,logic, loadTools: loadTools);
    }
  }


  Step _performActionLogic(BuildContext context,Map<String,double> values, String logic,{bool loadTools})
  {
    if(logic==null || logic.isEmpty){
      return null;
    }
    List<String> sep = logic.split(".");
    if(sep.length >=2)
    {
      String action = sep[0];
      String subject = sep[1];

      return _actionToSubject(context,action, subject,loadTools: loadTools);

    }else{
      return null;
    }
  }


  Step _actionToSubject(BuildContext context,String action, String subject,{bool loadTools})
  {
    switch(action)
    {
      case SHOW:
        return show(context,subject,loadTools: loadTools);
        break;

      default:
        return null;
        break;
    }
  }


  Step show(BuildContext context,String subject,{bool loadTools}) {
    Test t = this.tests[int.parse(subject)];
    t.isActive  = true;
    this.activeTests.add(t);
    return new Step(
        title: new Text(t.title),
        content: t.toShowTestsWidget(
            context, Test.TESTS_START_TEST_FROM_PROGRAM,loadTools: loadTools),
      isActive: true,
    );
  }


  Widget getResultWidget()
  {
    Map<String,double> values = this.getValues();
    List<String> results = MoLogic.performLogic(values, this._commentLogic);

    return getColumnText(results);
  }


  String getResult()
  {
      Map<String,double> values = this.getValues();
      List<String> results = MoLogic.performLogic(values, this._commentLogic);

      return results.last;
  }



  Widget getColumnText(List<String> texts)
  {
    List<Widget> widgets = new List();
    for(String s in texts){
      widgets.add(new Text(s,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ));
    }
    if(widgets.isEmpty){
      widgets.add(new Text(
          "No Results were found at this moment sorry! Please make sure to completly follow the program",
          style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ));
    }
    return Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets,
      ),
    );
  }


  /// get all the values from tests
  Map<String,double> getValues()
  {
    if(this._mapOfSavedValues!=null && this._mapOfSavedValues.isNotEmpty){
      print("got the map from the saved ones");
      return this._mapOfSavedValues;
    }
    Map<String,double> values = new Map();
    for(int i = 0;i<this.tests.length;i++){
      this.tests[i].getResults();
      values.addAll(this.tests[i].getIndexedMapOfResults(i));
    }
    return values;
  }



  void resetAllTests()
  {
    resetThisProgram();
    if(this.tests!=null){
      for(Test t in this.tests){
        t.refreshAllSubs(false);
      }
    }
  }


  void resetThisProgram()
  {
    this.mapOfSavedValues = new Map();
  }




  /// produces a  list of
  /// program results that are saved in the cloud
  Future<List<ProgramResult>> getResultsFromCloud() async
  {
    List<ProgramResult> prs = new List();
    await FirebaseDatabase.instance.reference()
        .child(Patient.PATIENT_PROGRAM_NORMAL)
        .child(Patient.currentPatient.id)
        .child(this.id).once().then((DataSnapshot data){
          if(data.value!=null){
            Map<dynamic,dynamic> map = data.value;
            map.forEach((dynamic key,dynamic value){
              ProgramResult pr = new ProgramResult();
              pr.toClass(value,ProgramResult.BASIC);
              prs.add(pr);
            });
            this.savedProgramResults = prs;
          }
    });
    return prs;
  }





  static Widget VIEW_PROGRAM (BuildContext context)
  {
    return MoButtons.titleDescriptionButton(
        context,
        Colors.black87,
        "Programs",
        "What is a standardized assessment of risk factors for falls? After universal fall precautions, a standardized assessment of risk factors for falls is the next step in fall prevention. By virtue of being ill, all patients are at risk for falls, but some patients are at higher risk than others.",
            (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowPrograms(1))));
        }
    );
  }


}
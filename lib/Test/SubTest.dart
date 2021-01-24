import 'dart:async';


import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/Show/ShowAProgram.dart';
import 'package:moction/Test/Tools.dart';
import 'package:flutter/material.dart';
import 'package:moction/Helpers.dart';
import 'package:moction/Json/Json.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/Test/Logic.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/MoWidgets/MoDialog.dart';
import 'package:moction/MoWidgets/MoTextFormField.dart';
import 'package:moction/Test/HelpMenu.dart';
import 'package:moction/Patient/ShowAllPatients.dart';
import 'package:moction/MoWidgets/MoId.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoPopUpMenu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:moction/Test/UniversalValues.dart';

import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/Show/ShowATest.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/MoWidgets/MoPdf.dart';


//import 'package:moction/ReactionTime/ReactionTime.dart';


import 'package:moction/Patient/Patient.dart';

class SubTest extends StatefulWidget implements HelpMenu
{
  ///sub tests must be a stateful widget

  @override
  SubTestState createState() => SubTestState();

  static const String SUBS = "SUBS";

  static const QUESTIONNAIRE = "QUESTIONNAIRE";
  static const NORMAL = "NORMAL";
  static const REACTION_TIME = "REACTION_TIME";
  static const CHOOSE_SUB_EXISTING = "CHOOSE_SUB_EXISTING";

  static const TYPE_OF_SUB_TESTS = [QUESTIONNAIRE,NORMAL,REACTION_TIME,CHOOSE_SUB_EXISTING];




  static const String SAVE = "SAVE";
  static const String TO_PDF = "TO PDF";
  static const TYPE_OF_TASK_ON_TEST = [SAVE, TO_PDF];


  static const String MODE_SAVE_SUBS_AND_TESTS = "MODE_SAVE_SUBS_AND_TESTS";




  static const String AVERAGE_TIME = "at";
  static const String AVERAGE_SCORE = "as";
  static const String TOTAL_TIME = "tt";
  static const String TOTAL_SCORE = "ts";
  static const String REACTION_AVERAGE_TIME = "rat";
  static const String REACTION_TOTAL_TIME = "rtt";
  static const String AVERAGE_LENGTH = "al";
  static const String TOTAL_LENGTH = "tl";
  static const String PATIENT_AGE = "pa";
  static const String PATIENT_GENDER = "pg";
  static const String PATIENT_DEVICE_HELP = "pdh";
/// we need to add an option to see if the patient has a device or not




  String _title;
  //description can also be a question
  String _description;
  String _typeOfSubTest;

  Color color;

  List<Tools> _tools;

  static const String TOOLS_ID = "TOOLS_ID";
  List<String> _toolsId;

  String _logic;





  String _id;
  dynamic data;
  bool loadTools;

  ///their index in the list
  int index;






  dynamic savedTools;

  Map<String,double> mapOfSavedResults;
  double countTimes;
  double totalTimes;
  double countScore;
  double totalScore;
  double totalLength;
  double countLength;

  //when they are doing the test
  // av time
  // av score
  // all time (tt)
  // all score (ts)


  SubTest(this._typeOfSubTest){
    this._title = "";
    this._description = "";

    this.color = Colors.black;
    this._tools = new List<Tools>();

    this._toolsId = new List();
    this.index = 0;

  }


  List<String> get toolsId => _toolsId;

  set toolsId(List<String> value) {
    _toolsId = value;
  }

  String get subId => _id;

  set subId(String value) {
    _id = value;
  }

  makeNewId()
  {
    this._id = MoId.generateRandomId(unique: this.title);
  }


  bool isLastIndex()
  {
    if(this.index == ShowATest.test.subs.length-1){
      return true;
    }
    return false;
  }

  bool isFirstIndex()
  {
    return this.index==0;
  }

  List<Tools> get tools => _tools;

  set tools(List<Tools> value) {
    _tools = value;
  }

  String get typeOfSubTest => _typeOfSubTest;

  set typeOfSubTest(String value) {
    _typeOfSubTest = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }


  refreshAllTools()
  {
    for(int i = 0;i<this.tools.length;i++){
      tools[i].restart();
    }
  }


  /// Widgets
  Widget getEditingWidget()
  {
    return new Column(
      children: <Widget>[
        new Text(this.title),
        new Text(this.description),

      ],
    );
  }




  Future<bool> idToClass(String id,{bool loadTags,VoidCallback state,bool loadTools}) async
  {
    await FirebaseDatabase.instance.reference().child(SUBS).child(id).once().then((data){
      if(data!=null){
        this.toClass(data.value,loadTags: loadTags,state: state,loadTools: loadTools);
        return true;
      }
    });
    return false;
  }


  update()
  {
    if(this._id!=null){
      FirebaseDatabase.instance.reference().child(SUBS).child(this._id).update(this.toJson());
    }
  }



  ///json
  toJson(){

    /// add cases
    /// it should be different for user and creator
    ///
    return {
      Helpers.NAME : this._title,
      Helpers.DESCRIPTION : this._description,

     // Helpers.SUBS : Json.listJson(this._tools),
      Helpers.TYPE : this._typeOfSubTest,
      Helpers.LOGIC : this._logic,
      Helpers.ID:  this._id,


      TOOLS_ID : Json.listJson_String(this._toolsId),

    };

  }


  toResult()
  {
    return {
      Helpers.TOOL:  this.toolsToResult()
    };
  }


  toolsToResult()
  {
    Map<String, Map> map = new Map();
    for(Tools tool in this.tools){
      map.putIfAbsent(tool.id, ()=> tool.toResult());
    }
    return map;
  }

  addBackSavedTools(dynamic data) async
  {
    if(this._tools.isEmpty){
      this.savedTools = data;
    }else if(data!=null){
      Map<dynamic, dynamic> map  = data;
      map.forEach((dynamic key, dynamic value){
       this.addBackThisTool(key, value);
      });
    }

  }

  int addBackThisTool(String id,dynamic data)
  {
    for(Tools t in this._tools){
      if(t.id!=null && t.id == id){
        t.toClassFromResult(data);
        return 1;
      }
    }
    return 0 ;
  }



  toClass(dynamic data,{bool loadTags, VoidCallback state,bool loadTools}) async
  {
    try{
      this.loadTools = loadTools;
      this.title = data[Helpers.NAME];
      this.description = data[Helpers.DESCRIPTION];
      this.typeOfSubTest = data[Helpers.TYPE];

     // this.tools = Json.jsonToClass(data[Helpers.SUBS]).cast<Tools>();
      this._logic = data[Helpers.LOGIC];
      this._id = data[Helpers.ID];

      this.data = data;

      ///
      ///
      /// make sure you have a way to find out how to parse a list of unknown keys and shit
      /// there might be still problems with the way tools work now because of editing the code a lot
      /// so make sure to test everything before moving to changing the subtests
      ///
      ///

      if(MoNotNull.boolean(loadTags)){
        this.toolsId = Json.loadJson_String(data[TOOLS_ID]);
      }else{

      }

        state();



    }catch(e){
      print("subtest error " + e.toString());
    }

  }

  String get logic => _logic;

  set logic(String value) {
    _logic = value;
  }


  /// getting the results of the test
  List<String> getResults()
  {


    /// we have to make it that the return value logic works here

      /// list for time
      List<double> lft = this.getTimeDoubles();
      double countT = lft[0];
      double sumT = lft[1];
      double avgT = 0;
      this.countTimes = countT;
      this.totalTimes = sumT;
      if(countT!=0){
        avgT = sumT/countT;
      }

      /// list for score
      List<double> lfs = this.getScoreDoubles();
      double countS = lfs[0];
      double sumS = lfs[1];
      double avgS = 0;
      this.countScore = countS;
      this.totalScore = sumS;
      if(countS!=0){
        avgS = sumS/countS;
      }

      /// list for data
      List<double> lfd = this.getDoublesForData();


      /// list for length
      List<double> lfl = this.getLengthDoubles();
      double countl = lfl[0];
      double suml = lfl[1];
      double avgl = 0;
      this.countLength = countl;
      this.totalLength = suml;
      if(countl!=0){
        avgl = suml/countl;
      }

      Map<String,double> map = new Map();
      map.putIfAbsent(SubTest.AVERAGE_TIME  , ()=> notZero(avgT));
      map.putIfAbsent(SubTest.AVERAGE_SCORE, ()=> notZero(avgS));
      map.putIfAbsent(SubTest.TOTAL_SCORE, ()=> notZero(sumS));
      map.putIfAbsent(SubTest.TOTAL_TIME, ()=> notZero(sumT));
      map.putIfAbsent(SubTest.REACTION_TOTAL_TIME, ()=> notZero(lfd[0]));
      map.putIfAbsent(SubTest.REACTION_AVERAGE_TIME, ()=> notZero(lfd[1]));
      map.putIfAbsent(SubTest.TOTAL_LENGTH, ()=> notZero(suml));
      map.putIfAbsent(SubTest.AVERAGE_LENGTH, ()=> notZero(avgl));

      if(Patient.currentPatient!=null){
        try{
          map[SubTest.PATIENT_AGE] = double.parse(Patient.currentPatient.age);
          map[SubTest.PATIENT_GENDER] = Patient.currentPatient.getGender();
          map[SubTest.PATIENT_DEVICE_HELP] = Patient.currentPatient.getDeviceHelp();
        }catch(e){

        }
      }


      this.mapOfSavedResults = map;

      return MoLogic.performLogic(map, this.logic);
  }


  /// returns the given number only if it is not zero
  /// if it is zero, it returns null
  notZero(double number){
    if(number==0){
      return null;
    }else{
      return number;
    }
  }



  List<double> getTimeDoubles()
  {
    double count = 0;
    double sum = 0;
    for(int i = 0;i<this.tools.length;i++){
      if(this.tools[i].typeOfTool == Tools.TIMER){
        try{
          sum+= tools[i].tool.timeSec();
          count++;
        }catch(e){
          print("time problem "+e.toString());
        }
      }
    }

    List<double> list = new List();
    list.add(count);
    list.add(sum);
    return list;
  }

  List<double> getLengthDoubles()
  {
    double count = 0;
    double sum = 0;
    for(int i = 0;i<this.tools.length;i++){
      if(this.tools[i].typeOfTool == Tools.INPUT){
        try{
          sum+= tools[i].tool.lengthCm();
          count++;
        }catch(e){

          print("length problem "+e.toString());
        }
      }
    }

    List<double> list = new List();
    list.add(count);
    list.add(sum);
    return list;
  }


  List<double> getScoreDoubles()
  {
    double count = 0;
    double sum = 0;
    for(int i = 0;i<this.tools.length;i++){
      Tools tool = tools[i];
      if(tool.typeOfTool != Tools.TIMER && tool.typeOfTool!=Tools.INPUT){
        try{
          if(tool.typeOfTool == Tools.SCORE){

            sum+= tools[i].tool.getScore();
            count++;
          }else if(tool.typeOfTool == Tools.BUTTON || tool.typeOfTool == Tools.CHECKER){
            if(tool.tool.wasPressed){
              sum+= double.parse(tools[i].tool.score);
              count++;
            }
          }

        }catch(e){
          print("getting total score problem: "+ e.toString());
        }
      }
    }
    List<double> list = new List();
    list.add(count);
    list.add(sum);

//    print("count score: " + count.toString());
//    print("sum score: " + sum.toString());

    return list;
  }


  List<double> getDoublesForData()
  {
    for(Tools tool in this.tools){
      if(tool.typeOfTool == Tools.DATA){
        return tool.tool.getResults();
      }
    }
    return [0,0];
  }



  bool toolsAreLoaded()
  {
    for(Tools t in this.tools){
      if(!t.isDoneLoading){
       // print(t.typeOfTool);
       // print("is done downloading : false");
        return false;
      }
    }
   // print("is done downloading : true");
    return true;
  }



  updateUniversalValues()
  {
    if(this.mapOfSavedResults==null){
      this.getResults();
    }

    UniversalValues universalValues = new UniversalValues(this.mapOfSavedResults, UniversalValues.UNIVERSAL_SUBS, this._id);
    universalValues.updateUniversal();
  }



  Future<bool> downloadTools() async
  {
    bool isDone = false;

    if(this.data!=null&&!this.hasLoaded){
      print("loading the tools from the class: " + this.title);
      Map<dynamic,dynamic> map = data[SubTest.TOOLS_ID];
      if(map!=null) {
        /// value is the id of the tool
        /// so we need to read the class
        /// from the database

        for(int i = 0; i<Json.LIMIT;i++){
          var value = map[i.toString() + Json.JASON];
          if(value == null){
            break;
          }else{
            Tools tool = new Tools("", "");
            await tool.idToClass(value);
            this.tools.add(tool);
          }
        }

//        map.forEach((dynamic key, dynamic value) async{
//          Tools tool = new Tools("", "");
//          await tool.idToClass(value);
//          this.tools.add(tool);
//        });
        isDone = true;
        print("just downloaded all tools (${this.tools.length}) for: "  + this.title);
      }
    }else{
      print("(already) loaded the tools from the class: " + this.title);
    }

    return isDone;
  }



  @override
  String notes;







  /// this is to only load the class once
  /// when going through more subtests
  bool hasLoaded = false;


  /// for searching a subtest and reusing it
  toSearch()
  {
    return this.title.toLowerCase() + " " + this.description.toLowerCase() + " " +  this.typeOfSubTest.toLowerCase();
  }

  Widget toSearchWidget(VoidCallback onTap)
  {
    return MoButton(
      radius: 15.0,
      onTap: onTap,
      color: Colors.grey,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text("Type: " + this.typeOfSubTest),
          new Text("title: "+ this.title),
          new Text("description: " + this.description),

        ],
      ),
    );
  }


}





class SubTestState extends State<SubTest> {

  Color themeColor;
  Color textColor;

  final double paddingDescription = 40;



  @override
  void initState() {
    // TODO: implement initState


    super.initState();



//    this.themeColor = MoColor.getColorBasedText(Colors.primaries, widget.title);
//    this.textColor = MoColor.getTextColor(this.themeColor);

    this.themeColor = MoColor.canvasColor;
    this.textColor = Colors.black;

    loadTools();

   // MoNotNull.boolean(widget.loadTools,returnThis: true)


  }


  loadTools()
  {
    if(widget.data!=null&&!widget.hasLoaded){
      Map<dynamic,dynamic> map = widget.data[SubTest.TOOLS_ID];
      if(map!=null) {
        /// value is the id of the tool
        /// so we need to read the class
        /// from the database

        for(int i = 0; i<Json.LIMIT;i++){
          var value = map[i.toString() + Json.JASON];
          if(value == null){
            break;
          }else{
            Tools tool = new Tools("", "");
            tool.idToClass(value,state: this.refresh,loadTools: widget.loadTools);
            widget.tools.add(tool);
          }
        }
//        map.forEach((dynamic key, dynamic value) {
//          Tools tool = new Tools("", "");
//
//          tool.idToClass(value,state: this.refresh,loadTools: widget.loadTools);
//          widget.tools.add(tool);
//        });

        widget.hasLoaded = true;
      }
    }else{
      refresh(forceRefresh: true);
    }

  }





  void refresh({bool forceRefresh}) async
  {
    print("refresh called");
    if(mounted){
      if(widget.toolsAreLoaded()||MoNotNull.boolean(forceRefresh)){
        await widget.addBackSavedTools(widget.savedTools);
      }
      setState(() {

      });
    }
  }






  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Theme(
      data: ThemeData(
        primaryColor: this.themeColor,
        toggleableActiveColor: this.themeColor
      ),
      child: Scaffold(
        backgroundColor: this.themeColor,
        floatingActionButton:

        ShowAProgram.program==null?
        SizedBox():
        new FloatingActionButton(onPressed: (){
          Navigator.pop(context);
        },child: new Icon(Icons.done),heroTag: null,backgroundColor: Colors.green,),

        body: Builder(
          builder: (context){
            return MoSliver(
            appBar: MoSliverAppBar(
             // title: new Text(Helpers.cut10(widget.title)),
              centerTitle: true,
              pinned: true,
              floating: true,
              snap: true,

              backgroundColor: themeColor,
              leading: widget.isFirstIndex() && ShowAProgram.program==null?new IconButton(icon: Icon(Icons.arrow_back,color: this.textColor,), onPressed: (){
                if(ShowAProgram.program!=null || ShowATest.result!=null){
                  Navigator.pop(context);
                }else{
                    MoDialog.showMoDialog(
                        context,
                        content: new Text("Are you sure you want to leave without saving?"),
                        actions: <Widget>[

                          new FlatButton(onPressed: (){
                            Navigator.pop(context);
                          } , child: new Text("No")),
                          new FlatButton(onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }, child: new Text("Yes")),
                        ]
                    );
                }

              }):SizedBox(),
              actions: <Widget>[
                //showPopUpMenu(context),
              ],
              height: MoSliverAppBar.MO_BAR_HEIGHT + 50,
              flexibleSpace: getFlexibleSpace()
//            ),
            ),
              bouncingScrollPhysics: true,
              padding: MoPaddingVersions.universal(),
              widgets: <Widget>[
                getTools(),
              ],
          );},
        ),
      ),
    );
  }


  Widget getResultButton()
  {
    return new FloatingActionButton(onPressed: (){
      print("choose a patient");
    },child: new Icon(Icons.done),heroTag: null,backgroundColor: Colors.green,);
  }


  getFlexibleSpace()
  {
    return FlexibleSpaceBar(
      // title: new Text(Helpers.cut10(widget.title),),
        background: SafeArea(
//                  child: Center(
            child: Padding(
              padding: EdgeInsets.only(left:paddingDescription-10,right:paddingDescription-10,bottom: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: MoTexts.outLineText(this.themeColor, this.textColor, Helpers.cutN(widget.title,9))),
                    Flexible(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(MoCard.ROUND_REC_RADIUS),
                          child: SingleChildScrollView(
                            child: (widget.description.isEmpty)?SizedBox(): MoCard(
                              backgroundColor: Colors.white,
                              elevation: 10.0,
                              cardRadius: MoCard.ROUND_REC_RADIUS,
                              childPadding: MoPadding(
                                  paddingAll: 16
                              ),
                              child: new Text(widget.description,
                                textAlign:TextAlign.start,style:
                                TextStyle(color:this.textColor,),),
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }



  showPopUpMenu(BuildContext context)
  {
    if(widget.isLastIndex() && ShowATest.result==null && ShowAProgram.program==null){
      return MoPopUpMenu(
        options: SubTest.TYPE_OF_TASK_ON_TEST,
        iconColor: this.textColor,
        onSelect: (dynamic command){

          switch(command){
            case SubTest.SAVE:
              onTapSave(context,firstTime: true);
              break;
//            case SubTest.TO_PDF:
//              MoPdf.createPdfTest(ShowATest.test,context);
//              break;
            default:
              break;
          }


        },
      );
    }
    return SizedBox();
  }




  onTapSave(BuildContext context,{bool firstTime})
  {
    /// if the patient is not null ask them to see if they want to save it for
    /// the same person
    /// or if they want to change it

    if(firstTime && Patient.currentPatient == null){
      /// they have to select a patient
      /// redirect them to their patients to choose one

      onReturnLaunch(context, false);

    }else{
      /// ask them to see if they want it for the same patient
      /// or they wanna search for another patient

      if(Patient.currentPatient!=null){
        MoDialog.showMoDialog(context,
            content: new Text("Do you want to save this test for " + Patient.currentPatient.fullName + " ?",textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(onPressed: (){
                /// save it here
                ///
                Patient.currentPatient.saveTest(ShowATest.test,context);
                Navigator.pop(context);
                Navigator.pop(context);
              }, child: new Text("Save")),
              new FlatButton(onPressed: (){
                onReturnLaunch(context, true);
              }, child: new Text("Choose a new patient"))
            ]);
      }

    }
  }

  onReturnLaunch(BuildContext context, bool hasDialog) async
  {
    if(hasDialog){
      Navigator.pop(context);
    }
    await Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowAllPatients(mode: Patient.SELECT_PATIENT,)));
    onTapSave(context,firstTime: false);
  }






  Widget getTools()
  {
    List<Widget> allTools = makeAllTools(widget.tools);


    return new Column(

      children: allTools,
    );
  }

  List<Widget> makeAllTools(List<Tools> tools)
  {
    List<Widget> all = new List<Widget>();



    for(int i = 0;i<tools.length;i++){
      Tools tool = tools[i];
      Widget toolWidget = GestureDetector(
        onLongPress: ()=> showHelpMenu(i),
          child: AnimatedContainer(
            duration: Duration(seconds: 1),

              child: tool.toWidget(
                  context: context,
                  textColor: textColor,
                  themeColor: themeColor,
                  type: Tools.WIDGET_SUB_TEST,
                refresh: refresh,
                tools: widget.tools,
              )
          )
      );
      all.add(toolWidget);
    }

    return all;
  }





  /// tool index show from which widget this menu was fired from
  ///
  /// if index == -1, it was fired from the app bar. which means it should go to the notes of this subtest
  showHelpMenu(int indexTool)
  {
    if(ShowATest.result!=null){
      return;
    }
    dynamic tool;
    if(tool==-1){
      tool = widget;
    }else{
      tool = widget.tools[indexTool];
    }

    showModalBottomSheet<void>(context: context,

        builder: (BuildContext cont) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Helpers.getListTile("Note", Icons.line_weight,onTap: (){
                MoTextFormField text = MoTextFormField(
                  hintText: "Enter a note",
                  text: tool.notes,
                  maxLines:4,
                  hasRoundBorders: true,


                  themeData: ThemeData(
                    primaryColor: Colors.black87
                  ),
                  iconData: Icons.line_weight,
                  labelText: "Notes",
                );
                Navigator.pop(cont);
                MoDialog.showMoDialog(
                    context,
                    title:  ClipRRect(
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(15.0),topRight: Radius.circular(15.0)),
                      child: new Container(
                        width: double.infinity,
                          height: 100.0,
                          color: themeColor,
                        child: Center(
                          child: new Text("Enter a note", style: TextStyle(color: this.textColor),),
                        ),
                      ),
                    ),
                    content: text,
                  actions: <Widget>[
                    FlatButton(onPressed: (){

                      setState(() {
                        tool.notes = text.controller.text;
                        print(tool.notes);

                        // check this text.dispose to see if the controller is being disposed
                        Navigator.of(context).pop();
                      });
                    }, child: new Text("Save",style: TextStyle(color: Colors.black),)
                    )
                  ]
                );
              })
            ],
          );
        });

  }






}




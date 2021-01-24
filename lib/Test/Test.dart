import 'package:firebase_database/firebase_database.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Show/ShowTests.dart';
import 'package:moction/Test/SubTest.dart';
import 'package:moction/Helpers.dart';
import 'package:moction/DateConvertor/MoDateConvertor.dart';
import 'package:moction/Json/Json.dart';
import 'package:flutter/material.dart';
import 'package:moction/Test/Logic.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/Firebase_Helpers/MoFirebase.dart';
import 'package:moction/MoWidgets/MoId.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/Make/MakeATest.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/Loaded.dart';
import 'package:moction/Show/ShowATest.dart';
import 'package:moction/Test/Result.dart';
import 'package:moction/Show/ShowPatientsTests.dart';
import 'package:moction/Test/UniversalValues.dart';
import 'package:moction/Test/Tools.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/Test/MoCode.dart';

class Test{



  String _title;
  String _description;

  DateTime _dateTime;
  List<SubTest> _subs;
  String _id;
  bool deleted;
  int _status;


  String notParsedLogic;
  String _logic;
  String _timeLogic;
  String _scoreLogic;
  String _lengthLogic;
  String _rangeLogic;

  List<String> _listOfSubIds;

  /// only can be used in conjunction with patient class
  Map<String,double> mapOfResults;
  List<Result> savedResults;


  double countTimes;
  double totalTimes;
  double countScore;
  double totalScore;
  double totalLength;
  double countLength;

  bool isActive;

  Map<dynamic,dynamic> mapOfSavedItems;



  static const int TEST = 1031;
  static const String TESTS_SUBS = "TESTS_SUBS";
  static const String TESTS_BASIC = "TESTS_BASIC";


  static const String TESTS_SHOW_RESULTS = "TSR";
  static const String TESTS_START_TEST = "TST";
  static const String TESTS_START_TEST_FROM_PROGRAM = "TSTFP";
  static const String TESTS_RETURN_TEST = "TRT";


  static const String TEST_GUIDE_START = "Choose an assessment to continue";
  static const String TEST_GUIDE_RESULT = "To see the saved results of a test, choose one to continue";


  static const String HERO_FOR_TEST  = "HFT";


  static const String RANGE_LOGIC = "@";


  /// used to determine the status of the test
  static const int PUBLIC = 1;
  static const int PRIVATE = 2;


 // static const String TEST_HERO_TAG = "tht";





  static const String NORMAL_COMMENT = "Please finish the test completly. We could not find any results based on your test.";

  Test(){
    this._title = "";
    this._description = "";
    this._logic = "";

    this.deleted = false;
    this._dateTime = DateTime.now();
    this._listOfSubIds = new List<String>();
    this._subs = new List<SubTest>();

    this.savedResults = new List();
    this.mapOfResults = new Map();

    this._timeLogic = "";
    this._scoreLogic = "";
    this._lengthLogic = "";
    this.isActive = false;
  }




  addId()
  {
    this._id = MoId.generateRandomId(unique: this.title);
  }

  String get logic => _logic;

  set logic(String value) {
    _logic = value;
  }




  List<String> get listOfSubIds => _listOfSubIds;

  set listOfSubIds(List<String> value) {
    _listOfSubIds = value;
  }

  List<SubTest> get subs => _subs;

  set subs(List<SubTest> value) {
    _subs = value;
  }

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime value) {
    _dateTime = value;
  }


  int get status => _status;

  set status(int value) {
    _status = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  Widget toShowTestsWidget(BuildContext context, String mode,{VoidCallback closeSearch,bool loadTools})
  {
    return Hero(
      tag: this.id,
      child: MoButtons.titleDescriptionButton(
          context,
          Colors.black87,
          title,
          description,
        ()=>this.onTapTest(context, mode,closeSearch: closeSearch,loadTools: loadTools),
        titleFont: 30
      ),

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
          onTap: ()=>onTapTest(context,mode,closeSearch: closeSearch,loadTools: loadTools),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  getShowWidget(Colors.white),
                  editATest(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// not permanent
  ///
  ///
  ///
  ///
  ///




  onTapTest(BuildContext context,String mode,{VoidCallback closeSearch,bool loadTools})
  {
    if(closeSearch!=null){
      closeSearch();
    }
    switch(mode)
    {
      case TESTS_SHOW_RESULTS:
        Loaded.currentTest = this;
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowPatientsTests())));
        break;
      case TESTS_START_TEST:
        ShowATest.test = this;
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowATest())));
        break;
      case TESTS_START_TEST_FROM_PROGRAM:
        ShowATest.test = this;
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowATest(
          refreshData: false,
          mode: TESTS_START_TEST_FROM_PROGRAM,
          loadTools: loadTools
        ))));
        break;
      default:
        break;
    }
  }


  Widget editATest(BuildContext context)
  {
    return new MoButton(
      text: "Edit",
      textColor: Colors.white,
      radius: 100.0,
      color: Colors.black,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (MakeATest(test: this ))));
      },
    );
  }

  ///
  ///
  ///
  ///
  ///
  /// not permanent




  ///widget
  Widget getShowWidget(Color c)
  {
    return new Column(
        children: <Widget>[
          Helpers.makeText(this.title, Helpers.TITLE_FONT_SIZE, c, true),
          SizedBox(height: 7.0,),
          Helpers.makeText(this.description, Helpers.DESCRIPTION_FONT_SIZE, c, true),
        ],
    );
  }

  Widget getTestWidget()
  {
    return new ListView.builder(
      itemCount: this.subs.length,
      scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          return this.subs[index];
        }
    );
  }


  List<Widget> getTabs()
  {
    List<Widget> widgets = new List();
    for(int i = 0;i<this.subs.length;i++){
      Tab tab = new Tab(

        text: this.subs[i].title,
      );
      widgets.add(tab);
    }
    return widgets;
  }

  List<Widget> getTabViews()
  {
    List<Widget> widgets = new List();
    for(int i = 0;i<this.subs.length;i++){
      widgets.add(Center(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: this.subs[i],
      )));
    }
    return widgets;
  }


  List<Widget> savedResultsWidget(BuildContext context)
  {
    if(this.savedResults!=null){
      List<Widget> widgets = new List();
      for(Result r in this.savedResults){
        widgets.add(r.toWidget(context,Result.NORMAL_RESULTS));
      }

      return widgets;
    }
    return [SizedBox()];
  }





  /// json and to Test functions
  toJson(String type){

    /// add cases
    /// it should be different for user and creator

    switch(type){
      case TESTS_SUBS:
        return {
          Helpers.SUBS : Json.listJson_String(this.listOfSubIds),
          Helpers.LOGIC : this.logic
        };
        break;
      case TESTS_BASIC:
        return {
          Helpers.NAME : this.title,
          Helpers.DESCRIPTION : this._description,
          Helpers.DELETED  :this.deleted,
          Helpers.ID  : this.id,
          Helpers.DATE_TIME : MoDateConvertor.getDateString(this.dateTime),
          Helpers.STATUS:  this.status
        };
        break;
    }






  }

  toClass(dynamic data, String type,{bool loadTags, bool loadTagsForSubTests,VoidCallback state,bool loadTools})
  {

    try{
      switch(type){
        case TESTS_SUBS:

          if(MoNotNull.boolean(loadTagsForSubTests)){
            /// load the tags of the sub only for editing purposes
            this.listOfSubIds = Json.loadJson_String(data[Helpers.SUBS]);
          }else{
            /// load the subs for a test
            Json.loadJson_idSubTest(data[Helpers.SUBS],loadTags: loadTags,state: state,loadTools: loadTools).then((List<SubTest> subs){
              this.subs = subs;
              if(state!=null){
                state();
              }
            });
          }

          parseLogic(data[Helpers.LOGIC]);


          break;
        case TESTS_BASIC:
          this.title = data[Helpers.NAME];
          this.description = data[Helpers.DESCRIPTION];
          this.id = data[Helpers.ID];
          this.deleted = data[Helpers.DELETED];

          this.dateTime = MoDateConvertor.getDateTimeFromString(data[Helpers.DATE_TIME]);

          try{
            var v = data[Helpers.STATUS];
            this.status = v==null?PUBLIC:v;
          }catch(e){
            this.status = PUBLIC;
          }

          if(state!=null){
            state();
          }
          break;
      }
    }catch(e){

      if(state!=null){
        state();
      }
    }
    return false;

  }



  loadBasic({VoidCallback state})
  {
    FirebaseDatabase.instance.reference().child(TESTS_BASIC).child(this.id).once().then((data){
      this.toClass(data.value, TESTS_BASIC,state: state);
    });
  }


  /// splits the logic into two logic
  /// normal
  /// and return logic
  parseLogic(String logic)
  {

    this.notParsedLogic = logic;
    // normal logic
    String nL = "";
    //time logic
    String tL = "";
    // score logic
    String sL = "";
    // length logic
    String lL = "";
    // range logic
    String rL = "";
    List<String> splitLogic = logic.split("\n");
    for(String s in splitLogic){
      String code = s.substring(1);
      if(s.startsWith(MoLogic.RETURN_LOGIC)){
        if(code.startsWith(MoCode.SCORE)){
          sL+= code+"\n";
        }else if(code.startsWith(MoCode.TIME)){
          tL+= code+"\n";
        }else if(code.startsWith(MoCode.LENGTH)){
          lL+= code+"\n";
        }
      }else if(s.startsWith(RANGE_LOGIC)) {
        rL+= code+"\n";
      }
      else{
        nL+=s+"\n";
      }
    }
    this.logic = nL;
    this._timeLogic = tL;
    this._scoreLogic = sL;
    this._lengthLogic = lL;
    this._rangeLogic = rL;

  }




/// results of the test
///  *** each individual subtest can have their own result
/// if their result is empty (no result) then the test returns its own result

  List<Widget> getResultsWidget(BuildContext context)
  {
    List<String> results = getResults();
    List<Widget> rWidgets = new List();

    for(String s in results){
      rWidgets.add(MoCard(
            childPadding: MoPadding(paddingAll: 16.0),
              padding: MoPadding(paddingWidths: 8.0,paddingHeights: 2.0),
              cardRadius: MoCard.ROUND_REC_RADIUS,
              backgroundColor: Theme.of(context).primaryColor,
              child: new Text(s,style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
      ));
    }

    if(rWidgets.isEmpty){
      rWidgets.add(MoCard(
          childPadding: MoPadding(paddingAll: 16.0),
          padding: MoPaddingVersions.universal(),
          cardRadius: MoCard.ROUND_REC_RADIUS,
          backgroundColor: Theme.of(context).primaryColor,
          child: new Text(NORMAL_COMMENT,style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
      ));
    }

    return rWidgets;
  }

  List<String> getResults()
  {

    this.mapOfResults.clear();
    List<String> results = new List();

    for(int i = 0;i<this.subs.length;i++){
      results+=this.subs[i].getResults();
    }

    this.updateTimeMap();
    this.updateScoreMap();
    this.updateReactionTimeMap();
    this.updateLengthMap();
    this.updatePatientMap();

    results += MoLogic.performLogic(this.mapOfResults, this.logic);

    return results;
  }

  updatePatientMap()
  {
    if(Patient.currentPatient!=null){
      try{
        this.mapOfResults[SubTest.PATIENT_AGE] = double.parse(Patient.currentPatient.age);
        this.mapOfResults[SubTest.PATIENT_GENDER] = Patient.currentPatient.getGender();
        this.mapOfResults[SubTest.PATIENT_DEVICE_HELP] = Patient.currentPatient.getDeviceHelp();
      }catch(e){

      }
    }
  }


  updateTimeMap()
  {
    /// list for time
    List<double> lft =
    (this._timeLogic.isEmpty)?this.getTimeDoubles():MoCode.getTotalAndCount(this._timeLogic, this);
    double countT = lft[0];
    double sumT = lft[1];
    double avgT = 0;
    if(countT!=0){
      avgT = sumT/countT;
    }

//    print("totalTime " + sumT.toString());
//    print("avTime " + avgT.toString());
    this.mapOfResults[SubTest.AVERAGE_TIME] = notZero(avgT);
    this.mapOfResults[SubTest.TOTAL_TIME] = notZero(sumT);

//    print(this.mapOfResults[SubTest.AVERAGE_TIME].toString());
//    print(this.mapOfResults[SubTest.TOTAL_TIME].toString());
  }


  updateScoreMap()
  {
    ///list for score
    List<double> lfs =
                (this._scoreLogic.isEmpty)?this.getScoreDoubles():MoCode.getTotalAndCount(this._scoreLogic, this);
    double countS = lfs[0];
    double sumS = lfs[1];
    double avgS = 0;
    if(countS!=0){
      avgS = sumS/countS;
    }

   //
    // print("total score:" +sumS.toString());

    this.mapOfResults[SubTest.AVERAGE_SCORE] = notZero(avgS);
    this.mapOfResults[SubTest.TOTAL_SCORE] = notZero(sumS);

  }


  updateLengthMap()
  {
    ///list for score
    List<double> lfs =
    (this._lengthLogic.isEmpty)?this.getLengthDoubles():MoCode.getTotalAndCount(this._lengthLogic, this);
    double countS = lfs[0];
    double sumS = lfs[1];
    double avgS = 0;
    if(countS!=0){
      avgS = sumS/countS;
    }

    //print("total length:" +sumS.toString());

    this.mapOfResults[SubTest.AVERAGE_LENGTH] = notZero(avgS);
    this.mapOfResults[SubTest.TOTAL_LENGTH] = notZero(sumS);

  }

  updateReactionTimeMap()
  {
    List<double> lfd = this.getDoublesForData();
    this.mapOfResults[SubTest.REACTION_TOTAL_TIME] = notZero(lfd[0]);
    this.mapOfResults[SubTest.REACTION_AVERAGE_TIME] = notZero(lfd[1]);
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


  toResult()
  {
    return this.subsToResult();
  }


  toSearch()
  {
    return this.title.toLowerCase() + " " + this.description.toLowerCase();
  }

  subsToResult()
  {
    Map<String, Map> map = new Map();
    for(SubTest sub in this.subs){
      map.putIfAbsent(sub.subId, ()=> sub.toResult());
    }
    return map;
  }

  List<double> getTimeDoubles()
  {
    double count = 0;
    double sum = 0;
    for(int i = 0;i<this.subs.length;i++){

      count+=this.subs[i].countTimes;
      sum+=this.subs[i].totalTimes;

//      List<double> lft = this.subs[i].getTimeDoubles();
//      double countT = lft[0];
//      double sumT = lft[1];
//      count+=countT;
//      sum+=sumT;
    }
    List<double> list = new List();
    list.add(count);
    list.add(sum);
    //print(list);

    return list;
  }


  List<double> getScoreDoubles()
  {
    double count = 0;
    double sum = 0;
    for(int i = 0;i<this.subs.length;i++){
      count+= this.subs[i].countScore;
      sum+=this.subs[i].totalScore;
//      List<double> lft = this.subs[i].getScoreDoubles();
//      double countT = lft[0];
//      double sumT = lft[1];
//      count+=countT;
//      sum+=sumT;
    }
    List<double> list = new List();
    list.add(count);
    list.add(sum);
   // print(list);
    return list;
  }


  List<double> getLengthDoubles()
  {
    double count = 0;
    double sum = 0;
    for(int i = 0;i<this.subs.length;i++){
      count+= this.subs[i].countLength;
      sum+=this.subs[i].totalLength;
    }
    List<double> list = new List();
    list.add(count);
    list.add(sum);
  //  print(list);
    return list;
  }

  List<double> getDoublesForData()
  {
    double count = 0;
    double sumAll = 0;
    double sumAve = 0;
    for(int i = 0;i<this.subs.length;i++){
      List<double> lft = this.subs[i].getDoublesForData();
      double sumT = lft[0];
      sumAve += lft[1];
      count++;
      sumAll+=sumT;
    }
    if(count!=0){
      sumAve /= count;
    }

    return [sumAll,sumAve];
  }




   getSubsOfTest({bool loadTags, bool loadTagsForSubTests,VoidCallback state, bool loadTools, VoidCallback regen }) async{
    await MoFirebase.getTestSubsRef().child(this.id).once().then((DataSnapshot data){
      if(data.value!=null){
        this.toClass(
            data.value,
            TESTS_SUBS,
            loadTags: loadTags,
            loadTagsForSubTests:loadTagsForSubTests,
            state: state,
          loadTools: loadTools
        );
      }
    }).then((v){
      if(regen!=null){
        regen();
      }
    });
  }


  refreshAllSubs(bool removeSavedTools)
  {
    for(int i = 0;i<this.subs.length;i++){
      this.subs[i].refreshAllTools();
      this.subs[i].savedTools = null;
    }
  }







  /// when coming back to a saved test
  addBackSavedSubs(String id, dynamic data,)
  {
    for(SubTest s in this.subs){
      if(s.subId == id){
        ///pass the data
        s.addBackSavedTools(data[Helpers.TOOL]);
        return;
      }
    }


  }


  startRegeneration({VoidCallback refresh})
  {
    if(this.mapOfSavedItems!=null){
      this.mapOfSavedItems.forEach((dynamic id,dynamic data){
        this.addBackSavedSubs(id, data);
      });
      if(refresh!=null){
        refresh();
      }
    }
  }





  /// adds the results of this test to the universal test collections
  updateUniversalValues()
  {
    _updateUniversalValuesForThis();
    _updateUniversalValuesForSubs();
  }

  _updateUniversalValuesForThis()
  {
    if(this.mapOfResults == null){
      this.getResults();
    }
    UniversalValues values = new UniversalValues(this.mapOfResults, UniversalValues.UNIVERSAL_TEST, this.id);
    values.updateUniversal();
  }

  _updateUniversalValuesForSubs()
  {
    for(SubTest subTest in this.subs){
      subTest.updateUniversalValues();
    }
  }






  Map<String,double> getIndexedMapOfResults(int index)
  {
    Map<String,double> map = new Map();
    if(this.mapOfResults!=null){
      this.mapOfResults.forEach((dynamic key, dynamic value){
        map.putIfAbsent(key +index.toString(), ()=> value==null?0:value);
      });
    }
    return map;
  }




  bool isPublic()
  {
    return this.status==PUBLIC;
  }

  bool isPrivate()
  {
    return this.status == PRIVATE;
  }


  final String SORRY_CAN_NOT_SAVE = "Sorry you can not save";
  List<dynamic> isGoodRange()
  {
    if(this._rangeLogic==null || this._rangeLogic.isEmpty){
      return [true,""];
    }else{
      List<String> runLogic = MoLogic.logicForEveryLine(this.mapOfResults, this._rangeLogic);
      if(runLogic!=null && runLogic.isNotEmpty){
        if(runLogic.first==RANGE_LOGIC){
          return [true,""];
        }else{
          return [false,runLogic.first];
        }
      }else{
        return [false,SORRY_CAN_NOT_SAVE];
      }

    }
  }




  /// downloads itself and everything below it
  /// including : subtests, tools , ...
  download() async
  {
    if(this.subs==null||this.subs.isEmpty){
      await this.getSubsOfTest();
      print("loading subtests from the actual test for: " + this.title);
    }
    for(SubTest sub in this.subs){
      await sub.downloadTools().then((bool isDone){
        print("isDone is called");
      });
    }
  }





  static Widget VIEW_TESTS (BuildContext context)
  {
    return MoButtons.titleDescriptionButton(
      context,
      Colors.black87,
      "Assesments",
      "What is a standardized assessment of risk factors for falls? After universal fall precautions, a standardized assessment of risk factors for falls is the next step in fall prevention. By virtue of being ill, all patients are at risk for falls, but some patients are at higher risk than others.",
    (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowTests(Test.TESTS_START_TEST,title: "Select a test to start",))));
    }
    );
  }




  static Future<Test> getAllResults() async
  {
    Test t = new Test();

    await FirebaseDatabase.instance.reference().child(Patient.PATIENT_TESTS_NORMAL).child(Patient.currentPatient.id).once().then((snap){

      var value = snap.value;
      Map<dynamic,dynamic> map = value;
      if(value!=null){
        map.forEach((key,value){
          //key is the id
          // value is the results

          Map<dynamic,dynamic> map1 = value;
          map1.forEach((key1,value1){
            Result result = new Result();
            result.toClass(value1, Result.NORMAL_RESULTS);
            result.test = Loaded.tests[key];
            t.savedResults.add(result);


          });

        });

        t.savedResults.sort((a,b) => double.parse(a.getId()).compareTo(double.parse(b.getId())));

        return t;
      }
    });

    return t;

  }




}
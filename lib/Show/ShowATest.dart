import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Show/ShowAProgram.dart';

import 'package:moction/Test/Test.dart';

import 'package:moction/Show/LoadATest.dart';
import 'package:moction/Show/ShowResultsTest.dart';
import 'package:moction/Test/Result.dart';
import 'package:moction/MoWidgets/MoLoadingScreen.dart';
import 'package:moction/MoWidgets/MoPageView.dart';
import 'package:moction/Patient/ShowAllPatients.dart';

// ignore: must_be_immutable
class ShowATest extends StatefulWidget {
  static Test test;
  static Result result;
  bool refreshData;
  bool loadTools;


  String mode;
  ShowATest({this.refreshData,this.mode,this.loadTools});



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ShowATestState();
  }
}

class ShowATestState extends State<ShowATest>{


  bool showLoading;
  MoLoadingScreen loadingScreen;


  bool showingSavedResults;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.showLoading = true;
    this.showingSavedResults = (ShowATest.result!=null)?true:false;
    loadingScreen = new MoLoadingScreen(Duration(milliseconds: 1500), Duration(milliseconds: 600));
    loadTest();


  }

  loadTest() async
  {

    /// problem when not downloading the sub tests again when trying to preview the old tests
    if(ShowATest.test.subs==null||ShowATest.test.subs.isEmpty){
      await ShowATest.test.getSubsOfTest(state: this.refresh,loadTools: widget.loadTools,regen: regen);
      print("loading subtest for " + ShowATest.test.title);
    }else if(MoNotNull.boolean(widget.refreshData,returnThis: true)){
      ShowATest.test.refreshAllSubs(ShowATest.result==null);
    }

    if(this.showingSavedResults){
      print("regenration");
      await ShowATest.result.loadSubsResults(refresh);
      ShowATest.test.startRegeneration();
    }













    refresh();
    if(mounted){
      this.showLoading = false;
      ShowATest.test.dateTime = DateTime.now();
    }

  }





  refresh()
  {
    if(this.mounted){
      super.setState((){});
    }
  }


  regen()
  {
    if(MoNotNull.boolean(widget.loadTools==false)){
      print("wtf regen");
      // print(ShowATest.test.mapOfSavedItems);
      ShowATest.test.startRegeneration();
    }
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Hero(
          tag: ShowATest.test.id,
            child: getBody()
        )
    );
  }

  Widget getBody(){
    //showLoading = false;
    //print(ShowATest.test.subs[0].subId);

    if(this.showLoading || ShowATest.test.subs.length==0){
      return this.loadingScreen;
    }



    regen();


    return new MoPageView(
      widgets: this.getWidgets(),
      pageSnapping: true,
      pageIndicator: true,
    );
//    return new PageView.builder(
//                pageSnapping: true,
//                itemCount: ShowATest.test.subs.length + 1,
//                  itemBuilder: (BuildContext context, int index){
//                  if(index == ShowATest.test.subs.length){
//                    return ShowResultsTest();
//                  }
//                    return ShowATest.test.subs[index];
//              });
  }


  List<Widget> getWidgets()
  {
    List<Widget> widgets = new List();
    widgets.addAll(ShowATest.test.subs);
    if(ShowATest.result!=null && MoNotNull.string(widget.mode)!=Test.TESTS_START_TEST_FROM_PROGRAM){
      widgets.add(ShowResultsTest());
    }else if(MoNotNull.string(widget.mode)!=Test.TESTS_START_TEST_FROM_PROGRAM){
      widgets.add(
          ShowAllPatients(
            noLeading: true,
            title:"Choose a patient to get the results for",
            mode: Patient.OPEN_RESULTS_TEST,
          )
      );

    }
    return widgets;
  }




  CrossFadeState getCrossFadeState()
  {
    if(this.showLoading || ShowATest.test.subs.length==0){
      return CrossFadeState.showFirst;
    }
    return CrossFadeState.showSecond;
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ShowATest.test = null;
    ShowATest.result = null;
  }


  
}

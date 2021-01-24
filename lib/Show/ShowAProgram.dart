import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/MoWidgets/MoDialog.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/MoWidgets/MoPdf.dart';
import 'package:moction/MoWidgets/MoPopUpMenu.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Patient/ShowAllPatients.dart';

import 'package:moction/Test/Program.dart';

import 'package:moction/Show/LoadATest.dart';
import 'package:moction/Show/ShowResultsTest.dart';
import 'package:moction/Test/ProgramResult.dart';
import 'package:moction/Test/Result.dart';
import 'package:moction/MoWidgets/MoLoadingScreen.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/MoWidgets/MoPageView.dart';
import 'package:moction/Test/Test.dart';

// ignore: must_be_immutable
class ShowAProgram extends StatefulWidget {
  static Program program;

  static ProgramResult result;




  ShowAProgram();



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ShowAProgramState();
  }
}

class ShowAProgramState extends State<ShowAProgram>{


  bool showLoading;

  MoLoadingScreen loadingScreen;



  int currentStep;

  bool isShowingResult;

  final String result = "Results";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.showLoading = true;
    this.currentStep = 0;
    this.isShowingResult = false;
    loadingScreen = new MoLoadingScreen(Duration(milliseconds: 1500), Duration(milliseconds: 600));
    loadTest();



  }

  loadTest() async
  {

    /// problem when not downloading the sub tests again when trying to preview the old tests
    if(ShowAProgram.program.tests==null||ShowAProgram.program.tests.isEmpty){
      await ShowAProgram.program.load(Program.PROGRAM_SUBS,state: refresh);
      print("loading subtest");
    }else{
//      ShowATest.test.refreshAllSubs(ShowATest.result==null);
    }






    if(mounted){
      this.showLoading = false;
      ShowAProgram.program.date = DateTime.now().toIso8601String();
      ShowAProgram.program.resetAllTests();
    }

    if(ShowAProgram.result!=null){
      print("regenration");
      await ShowAProgram.result.loadTestsForProgram(refresh);
      await ShowAProgram.result.loadSavedValuesForTests(refresh);
    }

    refresh();
  }

  refresh()
  {
    if(this.mounted){
      super.setState((){});
    }
  }



  @override
  Widget build(BuildContext context) {
    return  getBody(context);
  }

  Widget getBody(BuildContext context){
    //showLoading = false;
    //print(ShowATest.test.subs[0].subId);
    List<Widget> widgets = new List();
    if(this.showLoading || ShowAProgram.program.tests == null||ShowAProgram.program.tests.length==0){
      return this.loadingScreen;
    }else{
      return Theme(
        data: ThemeData(
          canvasColor: Colors.transparent
        ),
        child: Scaffold(
          backgroundColor: MoColor.canvasColor,
          resizeToAvoidBottomPadding: true,
          body:  Builder(
            builder: (context){
              return MoSliver(
                  padding: MoPadding(
                    paddingAll: 0,
                  ),
                  bouncingScrollPhysics: true,

                  appBar: MoSliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    backgroundHasOpacity: true,
                    backgroundColor: MoColor.canvasColor,
                    leading: new IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,), onPressed: (){
                      if(ShowAProgram.result!=null){
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

                    }),
                    actions: <Widget>[
                      showPopUpMenu(context)
                    ],
                      flexibleSpace: MoSliverAppBars.getFlexibleSpace(context,ShowAProgram.program.title, ShowAProgram.program.description,MoColor.canvasColor),
//                    flexibleSpace: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        MoSliverAppBars.centeredFlexSpace(
//                          MoTexts.titleText(context, (this.isShowingResult)?result:ShowAProgram.program.title,MoColor.canvasColor,align: TextAlign.center),
//                        ),
//                      ],
//                    ),
                  ),
                  child: getAnimatedTransition(context)
//          widgets: <Widget>[
//            getStepper(),
////            ShowAProgram.program.getTests(context)
//          ],
              );
            },
          ),
        ),
      );
    }

  }



  Widget getAnimatedOpacity()
  {
    return AnimatedOpacity(
        opacity: this.isShowingResult?1.0:0.0,
        duration: Duration(milliseconds: 500),
      child: new MoButton(
        color: Colors.black,
        paddingWidths: 40,
        radius: 50.0,
        text: this.isShowingResult?"Back to test": result,
        onTap: (){
          setState(() {
            this.isShowingResult = !this.isShowingResult;
          });
        },
      ),
    );

  }




  Widget getAnimatedTransition(BuildContext context)
  {

    return new AnimatedCrossFade(
        firstChild: this.getStepper(context,),
        secondChild: Row(
          children: <Widget>[
            Expanded(child: ShowAProgram.program.getResultWidget()),
          ],
        ),
        crossFadeState: fadeState(),
        duration: Duration(seconds: 1));
  }

  CrossFadeState fadeState()
  {
    if(this.isShowingResult){
      return CrossFadeState.showSecond;
    }
    return CrossFadeState.showFirst;
  }




  Widget getStepper(BuildContext context)
  {
    List<Step> steps = ShowAProgram.program.getSteps(context,loadTools: ShowAProgram.result==null);
    int length = steps.length;
    return new Stepper(
      physics: BouncingScrollPhysics(),
      controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Row(
          children: <Widget>[
            getContinueButton(length,context),
            getPreviousButton()
          ],
        );
      },
        onStepTapped: (newIndex){
        setState(() {
          this.currentStep = newIndex;
        });
        },
        currentStep: this.currentStep,
      key: new Key(length.toString()),
        steps: steps
    );
  }



  showPopUpMenu(BuildContext context)
  {
    if(ShowAProgram.result!=null){
      return SizedBox();
    }
    return MoPopUpMenu(
        options: Program.TYPE_OF_TASK_ON_PROGRAM,
        iconColor: Colors.black,
        onSelect: (dynamic command){

          switch(command){
            case Program.SAVE:
              onTapSave(context,firstTime: true);
              break;
            case Program.TO_PDF:
              MoPdf.createPdfProgram(ShowAProgram.program, context);
              break;
            default:
              break;
          }


        },
      );
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
          content: new Text("Do you want to save this program for " + Patient.currentPatient.fullName + " ?",textAlign: TextAlign.center),
          actions: <Widget>[
            new FlatButton(onPressed: (){
              /// save it here
              ///
              Patient.currentPatient.saveProgram(ShowAProgram.program,context);
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







  Widget getContinueButton(int length,BuildContext context)
  {
    return new MoButton(
      text: "Done",
      onTap: ()=> onStepContinue(length,context),
      radius: 50.0,
      color: Colors.green,
      textColor: Colors.white,
    );
  }


  onStepContinue(int length,BuildContext context)
  {
    setState(() {
      if(this.currentStep == length-1){

        Scaffold.of(context).showBottomSheet(
                (context){
                  return ClipRRect(
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(45.0),
                            topRight: const Radius.circular(45.0)),
                        child: Container(

                          height: 400.0,
                          width: double.infinity,
                          color: Colors.black87,
                          child: ShowAProgram.program.getResultWidget(),
                        ),
                  );

        });

        print("get results");
      }else{
        this.currentStep++;
      }
    });
  }


  Widget getPreviousButton()
  {
    if(this.currentStep==0){
      return SizedBox();
    }
    return new MoButton(
      text: "Previous",
      onTap: ()=> onStepPrevious(),
      radius: 50.0,
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  onStepPrevious()
  {
    setState(() {
      print("pre works");
      this.currentStep--;
    });
  }















  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ShowAProgram.program= null;
    ShowAProgram.result = null;
  }



}

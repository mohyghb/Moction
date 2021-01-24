import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/Patient/Patient.dart';

import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/Show/ShowTests.dart';
import 'package:moction/Test/Test.dart';
import 'package:moction/Show/ShowPrograms.dart';
import 'package:moction/Test/Program.dart';
import 'package:moction/Test/ProgramResult.dart';
import 'package:moction/Show/ShowAllResultsOfAProgram.dart';
import 'ShowAllTestsResults.dart';

// ignore: must_be_immutable
class ShowPatientProfile extends StatefulWidget {


  String mode;
  ShowPatientProfile({this.mode});



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ShowPatientProfileState();
  }
}

class ShowPatientProfileState extends State<ShowPatientProfile>{







  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }




  Widget getBody()
  {
    return MoSliver(
      flexTitle: getName(),
      widgets: <Widget>[
        getButtonForShowTests(),
        getButtonForShowPrograms(),
        getButtonForShowPatientInfo(),
      ],
    );
  }


  String getName()
  {
    if(Patient.currentPatient.fullName!=null){
      return Patient.currentPatient.fullName.split(" ")[0] + "'s Profile";
    }
    return "Profile";
  }

  Widget getButtonForShowTests()
  {
    return MoButton(
      text: "Show Saved Tests",
      onTap: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowTests(Test.TESTS_SHOW_RESULTS,title: "Select a test to get the results for",))));
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowAllTestResults())));
      },
    );
  }

  Widget getButtonForShowPrograms()
  {
    return MoButton(
      text: "Show Saved Programs",
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowPrograms(Program.SHOW_SAVED_PROGRAM_RESULTS))));
      },
    );
  }

  Widget getButtonForShowPatientInfo()
  {
    return MoButton(
      text: "Patient Info",
      onTap: (){
        /// open a window with all the patient information
      },
    );
  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



}

import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/MoWidgets/MoDialog.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Patient/ShowAllPatients.dart';
import 'package:moction/Show/ShowATest.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/Test/SubTest.dart';

class ShowResultsTest extends StatefulWidget
{

  @override
  _ShowResultsTestState createState() => _ShowResultsTestState();
}

class _ShowResultsTestState extends State<ShowResultsTest> {





  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: MoColor.canvasColor,
      floatingActionButton: Builder(builder: (context){return getSaveButton(context);}),
      body: Builder(
        builder: (context){
          return MoSliver(
            widgets: ShowATest.test.getResultsWidget(context),
            appBar: MoSliverAppBar(
              height: MoSliverAppBar.MO_BAR_HEIGHT + 50,
              backgroundColor: MoColor.canvasColor,

              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                            child: MoTexts.titleText(context,"Results",MoColor.canvasColor)
                        ),
                        MoCard(
                          childPadding: MoPaddingVersions.universal(),
                          cardRadius: MoCard.ROUND_REC_RADIUS,
                          elevation: MoCard.MID_ELEVATION,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          childRow: <Widget>[
                            Expanded(child: new Text("Age: "+ Patient.currentPatient.age,textAlign: TextAlign.center,)),
                            Expanded(child: new Text("Device Help: " + Patient.currentPatient.deviceHelp,textAlign: TextAlign.center)),
                            Expanded(child: new Text("Gender: " + Patient.currentPatient.gender,textAlign: TextAlign.center))
                          ],
                        ),
                        getWidgetFor("Time: ", ShowATest.test.mapOfResults[SubTest.TOTAL_TIME],"seconds"),
                        getWidgetFor("Score: ", ShowATest.test.mapOfResults[SubTest.TOTAL_SCORE],''),
                        getWidgetFor("Input: ", ShowATest.test.mapOfResults[SubTest.TOTAL_LENGTH],''),
                      ],
                    )
                ),
              ),
            ),


          );
        },
      ),
    );
  }




  Widget getWidgetFor(String title,double value,String unit)
  {
    if(value!=null && value!=0){
      return MoTexts.titleText(
          context,
          "",
          MoColor.canvasColor,
          fontSize: 20,
          bold: title + value.toString()+' '+ unit,
          maa: MainAxisAlignment.center,
          align: TextAlign.center
      );
    }
    return SizedBox();
  }


  Widget getSaveButton(BuildContext context)
  {
    if(ShowATest.result!=null){
      return SizedBox();
    }

    return new RaisedButton(
      onPressed: (){
        List<dynamic> res =ShowATest.test.isGoodRange();
        if(res[0]){
          onTapSave(context,firstTime: true);
        }else{
          /// show a bottom bar
          Scaffold.of(context).showSnackBar(
              SnackBar
                (content: new Text(res[1],textAlign: TextAlign.center,),
                backgroundColor: Colors.red,
              ));
        }
      },
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.cloud_done,color: Colors.white,),
            SizedBox(width: 10.0,),
            new Text("Save",style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
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
            content: new Text("Do you want to save this test for " + Patient.currentPatient.fullName + " ?",textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(onPressed: (){
                /// save it here
                ///
                Patient.currentPatient.saveTest(ShowATest.test,context);
                Navigator.pop(context);
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











}

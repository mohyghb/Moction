import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

import 'package:moction/MoWidgets/MoUseFullWidgets.dart';
import 'package:moction/MoWidgets/MoSliver.dart';

import 'package:moction/Organ/Organization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/Patient/MoSearch.dart';
import 'package:moction/MoWidgets/MoPadding.dart';


class ShowAllPatients extends StatefulWidget{

  ThemeData themeData;
  String mode;

  String title;
  bool noLeading;

  ShowAllPatients({this.themeData,this.mode,this.title,this.noLeading});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ShowAllPatientsState();
  }


}

class ShowAllPatientsState extends State<ShowAllPatients>{


  //List<Patient> patients;

  static const String NOT_FOUND_PATIENTS = "We could not find any patients currently.";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(Organization.currentOrgan.patients==null){
      loadBasicPatients(Patient.PATIENT_BASIC);
      print("loading patients");
    }


  }

  loadBasicPatients(String mode) async
  {


    await FirebaseDatabase.instance.reference()
        .child(Organization.ORGAN_PATIENTS).child(Organization.currentOrgan.id).once().then((data){

      Organization.currentOrgan.patients = new List();

      if(data!=null){
        Map<dynamic,dynamic> map = data.value;
        if(map!=null){
          map.forEach((dynamic patientId, dynamic deleted){

            if(!deleted[Organization.DELETED]) {
              Patient patient = new Patient();
              patient.idToClass(patientId, mode,refresh: this.refresh);
              Organization.currentOrgan.patients.add(patient);
            }
          });
        }
      }


    });
    if(mounted){
      setState(() {

      });
    }

  }

  void refresh()
  {
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Theme(
          data: MoNotNull.theme(widget.themeData, context),
          child: getBody(),
        ),
    );
  }


  Widget getBody()
  {
      return RefreshIndicator(
        onRefresh: refreshPatients,
        child: new MoSliver(
          padding: MoPaddingVersions.universal(),
          appBar: MoSliverAppBar(
            pinned: true,
            noLeading: widget.noLeading,
            actions: <Widget>[
              new IconButton(icon: Icon(Icons.search,color: Colors.black,), onPressed: (){
                if(Organization.currentOrgan.patients!=null){
                  showSearch(context: context, delegate: MoSearch(Organization.currentOrgan.patients, widget.mode,themeData: widget.themeData));
                }else{
                  print("we can not ");
                }

              })
            ],

            flexibleSpace: MoSliverAppBars.getFlexibleSpace(context,"Patient", widget.title,MoColor.canvasColor),
          ),
          widgets: getContent(),
        ),
      );
  }

  Future<Null> refreshPatients() async
  {
    loadBasicPatients(Patient.PATIENT_BASIC);
    print("refresh");
  }

  List<Widget> getContent()
  {
    List<Widget> widgets = new List();
    if(Organization.currentOrgan.patients==null){

      ///loading the patients
      widgets.add(MoUseFullWidgets.loading());

    }else if(Organization.currentOrgan.patients.isEmpty){
      /// could not find a patient
      widgets.add(MoUseFullWidgets.centerText(NOT_FOUND_PATIENTS, Icons.healing));
    }else {
      return Organizations.patientsToWidget(context,Organization.currentOrgan, mode: widget.mode, themeData: widget.themeData);
    }
    return widgets;
  }








}
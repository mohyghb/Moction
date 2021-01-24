import 'package:flutter/material.dart';
import 'package:moction/Helpers.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/MoWidgets/MoTextFormField.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/DateConvertor/MoDateConvertor.dart';
import 'package:moction/MoWidgets/MoId.dart';
import 'package:moction/Organ/Organization.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/MoWidgets/MoPopUpMenu.dart';
import 'package:moction/MoWidgets/MoCard.dart';

class Patient_Sign_Up extends StatefulWidget{

  ThemeData themeData;

  Patient_Sign_Up({this.themeData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Patient_Sign_Up_State();
  }


}

class Patient_Sign_Up_State extends State<Patient_Sign_Up>{

  Patient newPatient;

  MoTextFormField fullName;
  MoTextFormField phoneNumber;
  MoTextFormField address;
  MoTextFormField age;
  MoTextFormField email;


  //MoTextFormField status;

  /// test this out

  static const String THERAPIST = "Therapist";
  MoTextFormField therapist;

  static const String REFERRED_BY = "Referred By";
  MoTextFormField referredBy;

  static const String DOCTOR = "Doctor";
  MoTextFormField doctorName;
  MoTextFormField doctorNumber;


  List<MoTextFormField> moWidgets;

  GlobalKey<FormState> _key;
  GlobalKey<FormState> _key2;
  GlobalKey<FormState> _key3;




  String gender = Patient.MALE;
  String status;
  final String sQuestion = "What is your current status?";

  String deviceHelp;
  final String dhQuestion = "Do you use any kind of device to assist you in walking (e.g a cane)?";


  final double elevation = 10.0;
  final double childPadding = 12.0;

  @override
  void initState() {
    // TODO: implement initState


    super.initState();



    this.newPatient = new Patient();
    _key = new GlobalKey();
    _key2 = new GlobalKey();
    _key3 = new GlobalKey();


    moWidgets = new List();
    fullName = MoTextFormFields.FULL_NAME_TEXT_FIELD();
    phoneNumber = MoTextFormFields.PHONE_NUMBER_TEXT_FIELD(
      round: true,
      borderRadius: MoTextFormFields.CIRCLE_BORDER_RADIUS,
      paddingWidth: 0.0
    );
    address = MoTextFormFields.ADDRESS_TEXT_FIELD();
    age = MoTextFormFields.AGE_TEXT_FIELD();
    email = MoTextFormFields.EMAIL_TEXT_FIELD();

    therapist = MoTextFormFields.makeDynamicField_RecRound(
      hint: MoTextFormFields.ENTER_YOUR + THERAPIST,
      label:THERAPIST,
      icon: Icons.healing
    );

    this.referredBy = MoTextFormFields.makeDynamicField_RecRound(
      hint:"Who were you referred by?",
      label: REFERRED_BY,
      icon: Icons.person_add
    );


    this.doctorName = MoTextFormFields.makeDynamicField_RecRound(
      hint: "Full name of your doctor",
      label: "Patients Doctor (Full Name)",
      icon: Icons.person_pin
    );


    this.doctorNumber = MoTextFormFields.PHONE_NUMBER_TEXT_FIELD(
      round: true
    );
    this.doctorNumber.labelText = MoTextFormFields.PHONE_NUMBER + " Of Doctor";
    this.doctorNumber.hintText = "Enter A Phone Number";



//    status = MoTextFormFields.makeDynamicField_RecRound(
//      hint: "Enter your working status",
//      label: "Status",
//      icon: Icons.work
//    );
//
//    status.suffixIcon = new DropdownButtonHideUnderline(child: DropdownButton(items: ["Working","Not working"].map((String s){
//      return new DropdownMenuItem(child: new Text(s), value: s,);
//    }).toList(), onChanged: (String s){
//      status.controller.text = s;
//      print(s);
//    }));



    moWidgets.add(fullName);
    moWidgets.add(age);
    moWidgets.add(address);
    moWidgets.add(email);

    moWidgets.add(phoneNumber);

    moWidgets.add(therapist);
    moWidgets.add(referredBy);

    moWidgets.add(doctorName);
    moWidgets.add(doctorNumber);


    //moWidgets.add(status);

    /// syncing focus nodes so that the textfields 'next' moves the cursor to the next item
    /// and if there is no next item, then it is going to perform 'onDone'
    MoTextFormFields.syncFocusNodes(this.moWidgets, null);




//    moPopUpMenu = new MoPopUpMenu(
//      options: ["Working","Not Working"],
//      savedValue: MoPopUpMenu.STATUS,
//      themeData: widget.themeData,
//    );

  }



  onChangedGender(String newVal)
  {
    setState(() {
      this.gender = newVal;
    });
  }








  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Builder(
        builder: (context){ return Theme(
          data: MoNotNull.theme(widget.themeData, context),
          child: new MoSliver(
            padding: MoPaddingVersions.universal(),
            appBar: new MoSliverAppBar(
              pinned: true,
              flexTitle: "New Patient",
            ),
            widgets: <Widget>[

              this.getPersonalInformation(),
              this.getAddresses(),
              this.getDoctorInformation(),
              this.getStatusInformation(),
              this.getDeviceHelpInformation(),
              //MoTextFormFields.getForm(_key, moWidgets),
              MoButton(
                text: "Create New User",
                radius: 50.0,
                themeData: widget.themeData,
                onTap: ()=> createNewPatient(context),
              ),

            ],
          ),
        );}
      ),
    );
  }



  Widget getPersonalInformation()
  {
    return MoCard(
      backgroundColor: MoColor.canvasColor,
      childPadding: MoPadding(
          paddingAll: childPadding
      ),

      elevation: elevation,
      cardRadius: MoCard.ROUND_REC_RADIUS,
      childColumn: <Widget>[
       MoTextFormFields.getForm(_key,[this.fullName,this.age]),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Radio(
                value: Patient.MALE,
                groupValue: this.gender,
                onChanged: this.onChangedGender
            ),
            new Text("Male"),
            new Radio(
                value: Patient.FEMALE,
                groupValue: this.gender,
                onChanged: this.onChangedGender
            ),
            new Text("Female"),

          ],
        )
      ],
    );
  }

  Widget getAddresses()
  {
    return MoCard(
      backgroundColor: MoColor.canvasColor,
      childPadding: MoPadding(
          paddingAll: childPadding
      ),
      elevation: elevation,
      cardRadius: MoCard.ROUND_REC_RADIUS,
      childColumn: <Widget>[
        MoTextFormFields.getForm(_key2,[this.address,this.email,this.phoneNumber]),
      ],
    );
  }


  Widget getDoctorInformation()
  {
    return MoCard(
      backgroundColor: MoColor.canvasColor,
      childPadding: MoPadding(
          paddingAll: childPadding
      ),
      elevation: elevation,
      cardRadius: MoCard.ROUND_REC_RADIUS,
      childColumn: <Widget>[
        MoTextFormFields.getForm(_key3,[this.therapist,this.referredBy,this.doctorName,this.doctorNumber]),
      ],
    );
  }


  Widget getStatusInformation()
  {
    return MoCard(
      backgroundColor: MoColor.canvasColor,
      childPadding: MoPadding(
          paddingAll: childPadding+8
      ),
      elevation: elevation,
      cardRadius: MoCard.ROUND_REC_RADIUS,
      mainAxisSize: MainAxisSize.max,
      childColumn: <Widget>[
         statusWidget(),

      ],
    );
  }


  Widget getDeviceHelpInformation()
  {
    return MoCard(
      backgroundColor: MoColor.canvasColor,
      childPadding: MoPadding(
          paddingAll: childPadding+8
      ),
      elevation: elevation,
      cardRadius: MoCard.ROUND_REC_RADIUS,
      mainAxisSize: MainAxisSize.max,
      childColumn: <Widget>[
        getHelpDevice(),

      ],
    );
  }


  Widget statusWidget()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        this.status==null?SizedBox():new Text(sQuestion,style: TextStyle(color: Theme.of(context).primaryColor),),
        DropdownButton<String>(

          isExpanded: true,
          hint: new Text(sQuestion),
          value: this.status,
          underline: SizedBox(),
          onChanged: (String newValue) {
            setState(() {
              status = newValue;
            });
          },
          items: <String>[Patient.WORKING,Patient.NOT_WORKING]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
              .toList(),
        ),
      ],
    );
  }


  Widget getHelpDevice()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        this.deviceHelp==null?SizedBox():new Text(dhQuestion,style: TextStyle(color: Theme.of(context).primaryColor)),
        DropdownButton<String>(
          underline: SizedBox(),
          isExpanded: true,
          hint: new Text(dhQuestion),
          value: this.deviceHelp,
          onChanged: (String newValue) {
            setState(() {
              deviceHelp = newValue;
            });
          },
          items: <String>[Patient.YES,Patient.NO]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
              .toList(),
        ),
      ],
    );
  }








  createNewPatient(BuildContext context)
  {

    if( this._key.currentState==null|| this._key2.currentState==null|| this._key3.currentState==null||
    (this._key.currentState.validate() &&
        this._key2.currentState.validate() &&
        this._key3.currentState.validate())
    ){

      if(this.status == null){
        Helpers.showSnackBar("You need to choose an status.", true, context);
      }else if(this.deviceHelp == null){
        Helpers.showSnackBar("You need to choose whether you use a device to aid you in walking or not.", true, context);
      }else{
        try{
          newPatient.fullName = this.fullName.getText();
          newPatient.age = this.age.getText();
          newPatient.phoneNumber = this.phoneNumber.getText();
          newPatient.dateCreated = MoDateConvertor.getDateString(DateTime.now());

          newPatient.address = this.address.getText();
          newPatient.emailAddress = this.email.getText();

          newPatient.therapist = this.therapist.getText();
          newPatient.referredBy = this.referredBy.getText();
          newPatient.doctorFullName = this.doctorName.getText();
          newPatient.doctorNumber = this.doctorNumber.getText();
          newPatient.status = this.status;
          newPatient.gender = this.gender;
          newPatient.deviceHelp = this.deviceHelp;

          newPatient.id = MoId.generateRandomId(unique: newPatient.fullName);


          /// adding the new patient to the database
          newPatient.update(Patient.PATIENT_BASIC);
          newPatient.update(Patient.PATIENT_INFO);

          /// adding the ref of the new patient
          /// to the current organizations

          Organization.currentOrgan.editPatient(newPatient, false);


          Navigator.pop(context);
        }catch(e){
          Helpers.showSnackBar(e.toString(), true, context);
        }

      }
    }


  }




}
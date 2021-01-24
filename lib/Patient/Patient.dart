
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/Test/ProgramResult.dart';
import 'package:moction/Test/Test.dart';
import 'package:moction/MoWidgets/MoString.dart';
import 'package:moction/Test/Result.dart';
import 'package:moction/Show/ShowTests.dart';
import 'package:moction/Test/UniversalValues.dart';
import 'package:moction/Test/Program.dart';
import 'package:moction/Show/ShowPatientProfile.dart';
import 'package:moction/MoWidgets/MoPdf.dart';
import 'package:moction/Show/ShowResultsTest.dart';

class Patient{

  ///test this out
  ///

  static const String MALE = "M";
  static const String FEMALE = "F";
  static const List<String> GENDER_LIST = [MALE,FEMALE];


  static const String WORKING = "Working";
  static const String NOT_WORKING = "Not Working";
  static const String YES = "Yes";
  static const String NO = "No";


  static const String PATIENT_BASIC = "PATIENT_BASICS";
  static const String PATIENT_INFO  = "PATIENT_INFO";



  static const int ADD_PATIENT = 501;
  static const int PATIENT = 502;


  /// three different types of test saving
  /// one for dates and results
  /// one for subs
  /// one for graphing purposes
  static const String PATIENT_TESTS_NORMAL = "PATIENT_TESTS_NORMAL";
  static const String PATIENT_TESTS_SUBS = "PATIENT_TESTS_SUBS";
  static const String PATIENT_TESTS_MAPPED = "PATIENT_TESTS_MAPPED";
  static const String PATIENT_TESTS_UNIVERSAL = "PATIENT_TESTS_UNIVERSAL";


  static const String PATIENT_PROGRAM_NORMAL = "PATIENT_PROGRAM_NORMAL";
  static const String PATIENT_PROGRAM_SUBS = "PATIENT_PROGRAM_SUBS";
  static const String PATIENT_PROGRAM_MAPPED = "PATIENT_PROGRAM_MAPPED";
  static const String PATIENT_PROGRAM_UNIVERSAL = "PATIENT_PROGRAM_UNIVERSAL";


  static const String SELECT_PATIENT = "SELECT_PATIENT";
  static const String OPEN_PATIENT_PROFILE = "OPEN_PATIENT_PROFILE";
  static const String OPEN_RESULTS_TEST = "ORT";

  static const String FULL_NAME = "FULLNAME";
  static const String AGE = "AGE";
  static const String PHONE_NUMBER = "PHONENUMBER";
  static const String EMAIL = "EMAIL";
  static const String GENDER = "GENDER";
  static const String DEVICE_HELP = "DH";

  static const String THERAPIST = "THERAPIST";
  static const String ADDRESS = "ADDRESS";
  static const String DOCTOR_FULL_NAME = "DOCTORFULLNAME";
  static const String DOCTOR_NUMBER = "DOCTORNUMBER";
  static const String REFERRED_BY = "REFERREDBY";
  static const String DATE = "DATE";
  static const String ID = "ID";
  static const String STATUS = "STATUS";


  static const String NOT_PROVIDED = "Not provided";



  static Patient currentPatient;

  String _fullName;
  String _age;
  String _phoneNumber;
  String _emailAddress;
  String _gender;
  String _deviceHelp;


  String _therapist;
  String _address;
  String _doctorFullName;
  String _doctorNumber;
  String _referredBy;
  String _status;

  String _dateCreated;

  String _id;



  List<Test> savedTests;




  Patient(){
   this.savedTests = new List();
  }


  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get referredBy => _referredBy;

  set referredBy(String value) {
    _referredBy = value;
  }

  String get doctorFullName => _doctorFullName;

  set doctorFullName(String value) {
    _doctorFullName = value;
  }

  String get therapist => _therapist;

  set therapist(String value) {
    _therapist = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get fullName => _fullName;

  set fullName(String value) {
    _fullName = value;
  }

  String get age => _age;

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get kinesiologist => _therapist;

  set kinesiologist(String value) {
    _therapist = value;
  }

  String get emailAddress => _emailAddress;

  set emailAddress(String value) {
    _emailAddress = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  set age(String value) {
    _age = value;
  }

  String get dateCreated => _dateCreated;

  set dateCreated(String value) {
    _dateCreated = value;
  }

  String get doctorNumber => _doctorNumber;

  set doctorNumber(String value) {
    _doctorNumber = value;
  }


  String get gender => _gender==null?NOT_PROVIDED:_gender;

  set gender(String value) {
    _gender = value;
  }

  String get deviceHelp => _deviceHelp==null?NOT_PROVIDED:_deviceHelp;

  set deviceHelp(String value) {
    _deviceHelp = value;
  }

  bool isMale()
  {
    return this.gender == MALE;
  }
  bool isFemale()
  {
    return this.gender == FEMALE;
  }

  /// returns 0 if female , 1 otherwise
  double getGender()
  {
    if(this.isFemale()){
      return 0;
    }
    return 1;
  }


  double getDeviceHelp()
  {
    if(this.deviceHelp == YES){
      return 1;
    }else{
      return 0;
    }
  }


  toJson(String mode)
  {
    switch(mode){
      case PATIENT_BASIC:
        return {
          FULL_NAME : this.fullName,
          AGE : this.age,
          PHONE_NUMBER : this.phoneNumber,
          EMAIL  : this.emailAddress,
          ID : this.id,
          GENDER: this.gender,
          DEVICE_HELP: this.deviceHelp
        };
        break;
      case PATIENT_INFO:
        return {
          THERAPIST  : this.therapist,
          ADDRESS  : this.address,
          DOCTOR_FULL_NAME : this.doctorFullName,
          DOCTOR_NUMBER  : this.doctorNumber,
          DATE : this.dateCreated,
          REFERRED_BY  :this.referredBy,
          STATUS : this.status
        };
        break;
    }

  }

  update(String mode)
  {
    if(this.id!=null){
      FirebaseDatabase.instance.reference().child(mode).child(this.id).update(this.toJson(mode));
    }
  }


  toClass(dynamic data , String mode)
  {
    try{
      switch(mode){
        case PATIENT_BASIC:
          this.fullName = data[FULL_NAME];
          this.age = data[AGE];
          this.phoneNumber = data[PHONE_NUMBER];
          this.emailAddress = data[EMAIL];
          this.id = data[ID];
          this.gender = data[GENDER];
          this.deviceHelp = data[DEVICE_HELP];
          break;
        case PATIENT_INFO:
          this.therapist = data[THERAPIST];
          this.address = data[ADDRESS];
          this._doctorFullName = data[DOCTOR_FULL_NAME];
          this.doctorNumber = data[DOCTOR_NUMBER];
          this.dateCreated = data[DATE];
          this.referredBy = data[REFERRED_BY];
          this.status = data[STATUS];
          break;
      }
    }catch(e){

    }



  }


  /// mode can be either PATIENT_BASICS or PATIENT_TESTS
  idToClass(String id, String mode,{VoidCallback refresh}) async
  {
    FirebaseDatabase.instance.reference().child(mode).child(id).once().then((data){
      if(data!=null){
        this.toClass(data.value,mode);
        if(refresh!=null){
          refresh();
        }
      }
    });
  }



  /// to widget
  Widget toWidget(BuildContext context,{String mode,bool isSearching, ThemeData themeData})
  {
    /// wrap it in a ink well or gesture detector
    ///

    return Theme(
      data: MoNotNull.theme(themeData, context),
      child: MoCard(
          cardRadius: MoCard.ROUND_REC_RADIUS,
          backgroundColor: Theme.of(context).primaryColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(MoCard.ROUND_REC_RADIUS),
            onTap: ()=> this.onTap(context,mode: mode,isSearching: isSearching),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                children: <Widget>[
                  MoTexts.simpleText(context,this.fullName,Icons.person_outline,bold: MoTexts.NAME),
                  SizedBox(height: 4.0,),
                  MoTexts.simpleText(context,this.age,Icons.date_range,bold: MoTexts.AGE),
                  SizedBox(height: 4.0,),
                  MoTexts.simpleText(context,this.phoneNumber,Icons.phone_in_talk,bold: MoTexts.PHONE_NUMBER),
                  SizedBox(height: 4.0,),
                  MoTexts.simpleText(context,this.emailAddress,Icons.email,bold: MoTexts.EMAIL),
                ],
              ),
            ),
          ),
      )
    );
  }

  onTap(BuildContext context,{String mode,bool isSearching})
  {
    if(mode == null){
      /// opens the profile
      Patient.currentPatient = this;
      print("opening profile");
      Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowPatientProfile(mode: Test.TESTS_SHOW_RESULTS))));

    }
    else{
      if(MoNotNull.boolean(isSearching)){
        Navigator.pop(context);
      }
      switch(mode){
        case SELECT_PATIENT:
          Patient.currentPatient = this;
          Navigator.pop(context);
          break;
        case OPEN_PATIENT_PROFILE:
          Patient.currentPatient = this;


          /// open patient profile
          Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowPatientProfile(mode: Test.TESTS_SHOW_RESULTS))));

          break;
        case OPEN_RESULTS_TEST:
          Patient.currentPatient = this;
          print("opening results");

          Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowResultsTest())));
          break;
      }

    }
  }


  /// creates a string with containting info about the
  /// patient so it would be searchable
  String toSearch()
  {
    return this.fullName.toLowerCase() +" " + this.emailAddress.toLowerCase() + " " +this.phoneNumber + " " + this.age;
  }




  /// saves a result for the test inside the firebase database
  void saveTest(Test test,BuildContext context)
  {

    /// save the results and date time under the category of the test PATIENT_TEST_NORMAL
    /// save the subs under the category of test inside PATIENT_SUB_TEST
    ///


    Result result = new Result();
    result.result = MoString.convertList(test.getResults());
    result.dateTime = DateTime.now().toIso8601String();
    result.mapOfResults = test.toResult();
    //print(result.mapOfResults);

    _saveNormalTest(test,result);
    _saveSubTest(test,result);
    _saveMappedTest(test,result);
    test.updateUniversalValues();
   // print(test.mapOfResults);
    Universals.updatePatientUniversal(test.id, test.mapOfResults);


    MoPdf.nameOfPdf = result.dateTime;
    MoPdf.nameOfTheTestOrProgram = test.title;
    MoPdf.patientName = this._fullName;
    MoPdf.createPdfTest(test,context);
  }


  _saveNormalTest(Test test,Result result,{DatabaseReference reference})
  {
    if(reference!=null){
      reference.child(test.id).child(result.getId()).set(
          result.toJson(Result.NORMAL_RESULTS)
      );
    }else{
      FirebaseDatabase.instance.reference().child(PATIENT_TESTS_NORMAL).child(this.id).child(test.id).child(result.getId()).set(
          result.toJson(Result.NORMAL_RESULTS)
      );
    }

  }

  _saveSubTest(Test test, Result result,{DatabaseReference reference})
  {
    if(reference!=null){
      reference.child(test.id).child(result.getId()).set(
          result.toJson(Result.DETAILED_RESULTS)
      ).catchError((e){
        print(e.toString());
      });
    }else{
      FirebaseDatabase.instance.reference().child(PATIENT_TESTS_SUBS).child(this.id).child(test.id).child(result.getId()).set(
          result.toJson(Result.DETAILED_RESULTS)
      ).catchError((e){
        print(e.toString());
      });
    }

  }

  _saveMappedTest(Test test,Result result,{DatabaseReference reference})
  {
    if(test.mapOfResults==null){
      test.getResults();
    }
    if(reference!=null){
      reference.child(test.id).child(result.getId()).set(
          test.mapOfResults
      );
    }else{
      FirebaseDatabase.instance.reference().child(PATIENT_TESTS_MAPPED).child(this.id).child(test.id).child(result.getId()).set(
          test.mapOfResults
      );
    }

  }


  /// returns the test if this test has been loaded already
  /// else it returns null
  Test hasThisSaved(Test test)
  {
    for(Test t in this.savedTests){
      if(t.id == test.id){
        return t;
      }
    }
    return null;
  }



  Future<Test> loadNormalResult(Test test) async
  {
    Test val = hasThisSaved(test);
    if(val!=null){
    //  print("was already loaded");
      return val;
    }else{
      Test t = new Test();
      t.id = test.id;
      await FirebaseDatabase.instance.reference().child(PATIENT_TESTS_NORMAL).child(this.id).child(test.id).once().then((snap){

        Map<dynamic,dynamic> map = snap.value;
        if(map!=null){

          map.forEach((dynamic key, dynamic value){
            Result result = new Result();
            result.toClass(value, Result.NORMAL_RESULTS);
            t.savedResults.add(result);
          });
        }
        t.savedResults.sort((a,b) => double.parse(a.getId()).compareTo(double.parse(b.getId())));
      //  print("loadede the results of the test again");
      });
      this.savedTests.add(t);
      return t;
    }
  }







////  /// saves a program for the patient
  void saveProgram(Program program,BuildContext context)
  {
    ProgramResult programResult = new ProgramResult();
    programResult.program = program;
    programResult.date = DateTime.now().toIso8601String();
    programResult.result = program.getResult();

    for(Test test in program.tests){
      Result result = new Result();
      result.result = MoString.convertList(test.getResults());
      result.dateTime = DateTime.now().toIso8601String();
      result.mapOfResults = test.toResult();
      result.testId = test.id;

      programResult.testResults.add(result);

//      test.updateUniversalValues();
//      print(test.mapOfResults);
//      Universals.updatePatientUniversal(test.id, test.mapOfResults);
    }


    programResult.saveProgramResult(ProgramResult.BASIC, this, PATIENT_PROGRAM_NORMAL);
    programResult.saveProgramResult(ProgramResult.DETAILED, this, PATIENT_PROGRAM_SUBS);
    programResult.saveProgramResult(ProgramResult.MAP, this, PATIENT_PROGRAM_MAPPED);
//  programResult.saveProgramResult(ProgramResult.BASIC, this, PATIENT_PROGRAM_NORMAL);

    MoPdf.nameOfPdf = programResult.date;
    MoPdf.nameOfTheTestOrProgram = program.title;
    MoPdf.patientName = this._fullName;
    MoPdf.createPdfProgram(program, context);



  }


//




















}
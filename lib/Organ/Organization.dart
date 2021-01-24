
import 'package:firebase_database/firebase_database.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:flutter/material.dart';


class Organization{


  final String ORGAN_FULL_NAME = "FULL NAME";
  final String ORGAN_PHONE_NUMBER = "PHONE NUMNBER";
  final String ORGAN_EMAIL = "EMAIL";
  final String ORGAN_PASSWORD = "PASSWORD";
  static const String DELETED = "DELETED";
  static const String ID = "ID";


  /// change them by adding a '_' in between
  static const ORGAN_INFO = "ORGANINFO";
  static const ORGAN_PATIENTS= "ORGANPATIENTS";


  static Organization currentOrgan = new Organization();

  String _password;
  String _phoneNumber;
  String _email;
  String _fullName;
  bool _deleted;

  String _id;

  List<Patient> _patients;

  Organization(){
   this._deleted = false;
  }


  bool get deleted => _deleted;

  set deleted(bool value) {
    _deleted = value;
  }

  String get fullName => _fullName;

  set fullName(String value) {
    _fullName = value;
  }

  String get fullname => _fullName;

  set fullname(String value) {
    _fullName = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


  toJson(String mode)
  {
    switch(mode){
      case ORGAN_INFO:
        return {
          ORGAN_FULL_NAME : this.fullName,
          ORGAN_EMAIL : this.email,
          ORGAN_PHONE_NUMBER: this.phoneNumber,
          ORGAN_PASSWORD : this.password,
          DELETED:  this._deleted,
          ID : this.id
        };
        break;
      case ORGAN_PATIENTS:
        ///upload patients id
        break;
    }

  }

  toClass(dynamic data, String mode)
  {
    switch(mode){
      case ORGAN_INFO:
        this.fullName = data[ORGAN_FULL_NAME];
        this.email = data[ORGAN_EMAIL];
        this.phoneNumber = data[ORGAN_PHONE_NUMBER];
        this.password = data[ORGAN_PASSWORD];
        this.id = data[ID];
        this._deleted = data[DELETED];
        break;
      case ORGAN_PATIENTS:
        /// data has a list of strings for patients id
        break;
    }
  }


  update(String mode)
  {
    FirebaseDatabase.instance.reference().child(mode).child(this.id).update(this.toJson(mode));
  }


  idToClass(String oid, String mode)
  {
    FirebaseDatabase.instance.reference().child(mode).child(oid).once().then((data){
      if(data!=null){
        toClass(data.value, mode);
      }
    });
  }


  editPatient(Patient patient,bool deleted)
  {
    FirebaseDatabase.instance.reference().child(ORGAN_PATIENTS).
    child(this.id).
    child(patient.id).
    set({DELETED :deleted}).catchError((e){
      print(e);
    });
  }

  List<Patient> get patients => _patients;

  set patients(List<Patient> value) {
    _patients = value;
  }

}



class Organizations
{
//  static loadPatients(String mode)
//  {
//    Organization.currentOrgan.patients = new List();
//
//    FirebaseDatabase.instance.reference()
//        .child(Organization.ORGAN_PATIENTS).child(Organization.currentOrgan.id).once().then((data){
//
//      Map<dynamic,dynamic> map = data.value;
//      map.forEach((dynamic patientId, dynamic deleted){
//
//        if(!deleted[Organization.DELETED]){
//          Patient patient = new Patient();
//          patient.idToClass(patientId, mode);
//          Organization.currentOrgan.patients.add(patient);
//        }
//      });
//
//    });
//  }


  static List<Widget> patientsToWidget(BuildContext context,Organization organization,{String mode, ThemeData themeData})
  {
    List<Widget> widgets = new List();
    organization.patients.forEach((patient){
      widgets.add(patient.toWidget(context,mode: mode, themeData: themeData));
    });
    return widgets;
  }


}
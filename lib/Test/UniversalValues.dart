

import 'package:firebase_database/firebase_database.dart';
import 'package:moction/Patient/Patient.dart';


class UniversalValues
{

  static const String UNIVERSAL_TEST = "UNIVERSAL_T";
  static const String UNIVERSAL_TEST_AGE_BASED = "UNIVERSAL_T_AGE";
  static const String UNIVERSAL_SUBS = "UNIVERSAL_S";
  static const String UNIVERSAL_SUBS_AGE_BASED = "UNIVERSAL_S_AGE";

  /// universal values like counter
  static const String COUNTER = "COUNTER";

  String mode;
  String date;
  Map<dynamic,dynamic> newValues;
  String testOrSubId;

  UniversalValues(this.newValues,this.mode,this.testOrSubId)
  {
    this.date = DateTime.now().toIso8601String();
    this.newValues.remove(COUNTER);
    if(this.shouldUpdateCounter()){
      this.newValues.putIfAbsent(COUNTER, ()=> 1.0);
      print("added counter");
    }else{
      //this.newValues.putIfAbsent(COUNTER, ()=> 0.0);
    }
  }


  bool shouldUpdateCounter()
  {
    bool state = false;
    this.newValues.forEach((dynamic key,dynamic value){
      if(value!=null){
        state = true;
      }
    });
    return state;
  }


  Map<dynamic,dynamic> addOldAndNew(Map<dynamic,dynamic> oldValues)
  {
    if(oldValues == null){
      return this.newValues;
    }
    newValues.forEach((dynamic key,dynamic value){
      if(value!=null && oldValues.containsKey(key)){
        oldValues[key] += value;
      }else if(value!=null){
        oldValues.putIfAbsent(key, ()=> value);
      }
    });

    /// setting new values of the universal class

    return oldValues;
  }

  updateUniversal() async
  {
    await FirebaseDatabase.instance.reference()
        .child(this.mode)
        .child(this.testOrSubId)
        .runTransaction((transaction) async{
          Map<dynamic,dynamic> oldValues = await transaction.value;
          dynamic newVal = addOldAndNew(oldValues);
          transaction.value = newVal;
      return transaction;

    });
    updateAgeBasedUniversal();
  }




  updateAgeBasedUniversal() async
  {
    this.newValues.remove(COUNTER);
    print("uploaded this: " + this.newValues.toString());
    await FirebaseDatabase.instance.reference()
        .child(this.getAgeMode())
        .child(this.testOrSubId)
        .child(Patient.currentPatient.age)
        .child(Patient.currentPatient.id)
        .child(this.getDateId())
        .set(this.newValues);
  }

  String getAgeMode()
  {
    switch(this.mode){
      case UNIVERSAL_TEST:
        return UNIVERSAL_TEST_AGE_BASED;
      case UNIVERSAL_SUBS:
        return UNIVERSAL_SUBS_AGE_BASED;
    }
    return null;
  }

  String getDateId()
  {
      return this.date
          .replaceAll(".", "")
          .replaceAll("T", "")
          .replaceAll("-", "")
          .replaceAll(":", "")
      ;
  }


}


class Universals{

  static updatePatientUniversal(String testId, Map<dynamic,dynamic> newValues) async
  {
    await FirebaseDatabase.instance.reference()
        .child(Patient.PATIENT_TESTS_UNIVERSAL)
        .child(Patient.currentPatient.id)
        .child(testId)
        .runTransaction((transaction) async{


      Map<dynamic,dynamic> oldValues = await transaction.value;
      dynamic newVal = addOldAndNew(oldValues,newValues);
      transaction.value = newVal;


      return transaction;

    });
  }


  static Map<dynamic,dynamic> addOldAndNew(Map<dynamic,dynamic> oldValues, Map<dynamic,dynamic> newValues)
  {
    if(oldValues == null){
      return newValues;
    }
    newValues.forEach((dynamic key,dynamic value){
      if(value!=null && oldValues.containsKey(key)){
        oldValues[key] += value;
      }else if(value!=null){
        oldValues.putIfAbsent(key, ()=> value);
      }
    });

    /// setting new values of the universal class

    return oldValues;
  }
}
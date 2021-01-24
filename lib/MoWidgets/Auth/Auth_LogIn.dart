

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:moction/MoWidgets/MoButton.dart';

import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoTextFormField.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

import 'package:moction/Organ/Organization.dart';
import 'package:moction/main.dart';
import 'package:moction/MoWidgets/MoPadding.dart';


class AuthLogIn extends StatefulWidget
{

  bool addUsername;
  bool addPassword;
  bool addName;
  bool addLastName;
  bool addPhoneNumber;
  bool addEmail;
  bool addFullName;

  /// if this is false, the authentication process
  /// is continued with checking the phoneNumber
  bool authWithEmailPassword;


  /// adding customizable options for the user
  ThemeData themeData;


  AuthLogIn({
    this.addPhoneNumber,
    this.addEmail,
    this.addLastName,
    this.addName,
    this.addPassword,
    this.addUsername,
    this.authWithEmailPassword,

    this.themeData,
  });

  @override
  _AuthLogInState createState() => _AuthLogInState();
}

class _AuthLogInState extends State<AuthLogIn> {



  final FirebaseAuth _auth = FirebaseAuth.instance;

  MoTextFormField name;
  MoTextFormField lastName;
  MoTextFormField phoneNumber;
  MoTextFormField username;
  MoTextFormField password;
  MoTextFormField email;
  MoTextFormField fullName;

  GlobalKey<FormState> _key = new GlobalKey();


  List<MoTextFormField> widgets;


  //initializer
  void initState()
  {
    initClass();
    super.initState();
  }


  void initClass()
  {
    widgets = new List();

    /// init only if the super class booleans are true for them
    ///



    initIfTrue(MoTextFormFields.EMAIL_TEXT_FIELD(),widget.addEmail);
    initIfTrue(MoTextFormFields.USERNAME_TEXT_FIELD(),widget.addUsername);
    initIfTrue( MoTextFormFields.PASSWORD_TEXT_FIELD(),widget.addPassword);

    initIfTrue(MoTextFormFields.NAME_TEXT_FIELD(), widget.addName);
    initIfTrue(MoTextFormFields.LAST_NAME_TEXT_FIELD(), widget.addLastName);
    initIfTrue(MoTextFormFields.FULL_NAME_TEXT_FIELD(), widget.addFullName);
    initIfTrue(MoTextFormFields.PHONE_NUMBER_TEXT_FIELD(), widget.addPhoneNumber);



    /// so that when pressed next on keyboard, it moves the cursor to the next
    /// MoText
    /// Null is the function that should be passed to the last node
    MoTextFormFields.syncFocusNodes(this.widgets, ()=> this.logIn());

  }


  void initIfTrue(MoTextFormField field, bool b)
  {
    if(MoNotNull.boolean(b)){
      switch(field.labelText){
        case MoTextFormFields.PASSWORD:
          this.password = field;
          this.widgets.add(password);
          break;
        case MoTextFormFields.USERNAME:
          this.username = field;
          this.widgets.add(username);
          break;
        case MoTextFormFields.NAME:
          this.name = field;
          this.widgets.add(name);
          break;
        case MoTextFormFields.LAST_NAME:
          this.lastName = field;
          this.widgets.add(lastName);
          break;
        case MoTextFormFields.FULL_NAME:
          this.fullName = field;
          this.widgets.add(fullName);
          break;
        case MoTextFormFields.PHONE_NUMBER:
          this.phoneNumber = field;
          this.widgets.add(phoneNumber);
          break;
        case MoTextFormFields.EMAIL:
          this.email = field;
          this.widgets.add(email);
          break;
      }
    }
  }













  //produces the scaffold of the createAppointment
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getBody(context);
//
  }





  //produces the body of the manger
  Widget getBody(BuildContext context)
  {
    return Theme(
      data: MoNotNull.theme(widget.themeData, context),
      child: MoSliver(
        padding: MoPaddingVersions.universal(),
        appBar: MoSliverAppBars.getMoSliverAppBar(
            context,
            "Log-In",
          color: MoNotNull.theme(widget.themeData, context).primaryColor,
          noLeading: true
        ),
        widgets: <Widget>[
          MoTextFormFields.getForm(_key, widgets),
          MoButton(
            text: "Log in",
            radius: 100,
            paddingWidths: 85.0,
            onTap: logIn,
          ),
          new Center(
            child: new Text("Swipe left to Sign-Up",textAlign: TextAlign.center,style: TextStyle(color: Colors.black54),),
          ),
        ],

      ),
    );
  }


  void logIn()
  {
    if(this._key.currentState.validate()){
      _auth.signInWithEmailAndPassword(email: this.email.getText(), password: this.password.getText()).then((FirebaseUser user){
        Organization.currentOrgan.idToClass(user.uid,Organization.ORGAN_INFO);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }).catchError((error){
        /// either the password or the email is wrong or the account might have been deleted
        print(error.toString());
      });
    }
  }





















}

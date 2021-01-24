import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/MoWidgets/MoTextFormField.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/Organ/Organization.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/main.dart';

// ignore: must_be_immutable
class AuthSignUp extends StatefulWidget
{

  /// adds a text field for each if true
  bool addUsername;
  bool addPassword;
  bool addName;
  bool addFullName;
  bool addLastName;
  bool addPhoneNumber;
  bool addEmail;

  /// if this is false, the authentication process
  /// is continued with checking the phoneNumber
  bool authWithEmailPassword;


  /// adding customizable options for the user
  ThemeData themeData;


  AuthSignUp({
    this.addPhoneNumber,
    this.addEmail,
    this.addLastName,
    this.addName,
    this.addPassword,
    this.addUsername,
    this.addFullName,

    this.authWithEmailPassword,

    this.themeData,
  });

  @override
  _AuthSignUpState createState() => _AuthSignUpState();
}

class _AuthSignUpState extends State<AuthSignUp> {


  /// constants
  static const double SLIVER_HEIGHT = 300.0;

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
    initIfTrue(MoTextFormFields.PHONE_NUMBER_TEXT_FIELD(
      normal: true
    ), widget.addPhoneNumber);



    /// so that when pressed next on keyboard, it moves the cursor to the next
    /// MoText
    /// Null is the function that should be passed to the last node
    MoTextFormFields.syncFocusNodes(this.widgets, ()=> this.signUp());

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
    return Theme(data:MoNotNull.theme(widget.themeData, context),child: getBody(context));
  }





  //produces the body of the manger
  Widget getBody(BuildContext context)
  {
    return MoSliver(
      padding: MoPaddingVersions.universal(),
      appBar: MoSliverAppBars.getMoSliverAppBar(
          context,
          "Sign-Up",
          color: MoNotNull.theme(widget.themeData, context).primaryColor,
          noLeading: true
      ),
      widgets: <Widget>[
        MoTextFormFields.getForm(_key, widgets),
        this.signUpButton()
      ],

    );

  }










  Widget signUpButton()
  {
    return Theme(
      data: MoNotNull.theme(widget.themeData,context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new MoButton(
            iconData: Icons.verified_user,
            spaceBetweenTI: 6.0,
            text: "Sign up",
            radius: 100.0,
            onTap: signUp,
        ),
      ),
    );
  }



  /// signs up the user if all the fields are filled
  /// and the user has gotten a token for signing up
  /// they can buy tokens.
  /// based on how long they wanna use it for
  /// the price changes
  void signUp() async
  {
    if(this._key.currentState.validate()){
      this.email.getText();
      _auth.createUserWithEmailAndPassword(
          email: this.email.getText(),
          password: this.password.getText())
          .then((FirebaseUser user){

        Organization organization = new Organization();
        organization.fullName = this.name.getText()+ " " + this.lastName.getText();
        organization.password = this.password.getText();
        organization.email = this.email.getText();
        organization.phoneNumber = this.phoneNumber.getText();
        organization.id = user.uid;

        print("working....");

        organization.update(Organization.ORGAN_INFO);

        ///update the current organization
        Organization.currentOrgan = organization;

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));

      });
    }
  }

  /// returns true if all the required fields are filled
  /// with correct information
  ///
  bool everythingIsFilled()
  {
    return false;
  }




















  @override
  void dispose() {

    super.dispose();
  }




}

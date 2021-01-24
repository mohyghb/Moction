import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/Auth/Auth_LogIn.dart';
import 'package:moction/MoWidgets/Auth/Auth_SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moction/main.dart';
import 'package:moction/Organ/Organization.dart';


class Auth extends StatefulWidget
{

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {


  /// list of authentication
  /// including:
  /// sign up
  /// log in
  List<Widget> _authList;

  bool loading;


  //initializer
  void initState()
  {
    loading = true;
    signedInAlready();
    initClass();
    super.initState();
  }

  void signedInAlready()
  {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      if(user!=null){
        Organization.currentOrgan.idToClass(user.uid,Organization.ORGAN_INFO);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }else{
        setState(() {
          loading = false;
          print("not singed in");
        });
      }
    });
  }


  void initClass()
  {
    _authList = new List();
    _authList.add(new AuthLogIn(
      addEmail: true,
      addPassword: true,
      themeData: new ThemeData(
        primaryColor: Colors.indigo
      ),
    ));
    _authList.add(new AuthSignUp(
      authWithEmailPassword: false,
      addPhoneNumber: true,
      addEmail: true,
      addLastName: true,
      addName: true,
      addPassword: true,
      themeData: new ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.black,
      ),
    ));


  }









  //produces the scaffold of the createAppointment
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(

      body: getBody(),
      resizeToAvoidBottomPadding: true,
    );
  }





  //produces the body of the manger
  Widget getBody()
  {
    if(loading){
      return new Text("loading");
    }else{
      return PageView(
        children: <Widget>[
          _authList[0],
          _authList[1]
        ],
      );
    }

  }























}

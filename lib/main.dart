import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//design
import 'package:moction/AppBar/Appbar.dart';
import 'package:moction/Helpers.dart';
import 'package:moction/Make/MakeATest.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Show/ShowTests.dart';


import 'package:moction/MoWidgets/Auth/Auth.dart';
import 'package:moction/Patient/Patient_Sign_Up.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:moction/Patient/ShowAllPatients.dart';
import 'package:moction/Test/MoData.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/Test/Program.dart';
import 'package:moction/Test/Test.dart';
import 'package:moction/Make/MakeAProgram.dart';
import 'package:moction/Show/ShowPrograms.dart';
import 'package:moction/MoWidgets/MoPdf.dart';
import 'package:moction/Test/Logic.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Moction',

        theme: new ThemeData(
          primaryColor: Colors.blueGrey,
          accentColor:  Colors.blueGrey[300],
          canvasColor: MoColor.canvasColor,
          backgroundColor: Colors.white,
          splashColor: Colors.white,
          cursorColor: Colors.black,
          cardColor: Colors.white,
          disabledColor: Colors.white70,
        ),
        home: Auth(),
        routes: <String, WidgetBuilder> {
          '/home': (BuildContext context) => MyHomePage()
        }
    );
  }
}

class MyHomePage extends StatefulWidget
{

  static String TITLE = 'Moction';


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  int bodyIndex;
  List<Widget> bodyWidgets;
  final double paddingDescription = 40;


  @override
  void initState() {
    // TODO: implement initState
    initClass();

    super.initState();

  }

  void initClass() async
  {





    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));



  //  print(DateTime.now().toString());
  }


  //produces the scaffold of the main menu
  @override
  Widget build(BuildContext context) {
//    if(!appSwitch){
//      return new Scaffold(
//        backgroundColor: Colors.red,
//        body: SafeArea(child: Center(child: new Text("Sorry, there was a problem. Talk to the developer if this error is unexpected.",textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: Helpers.TITLE_FONT_SIZE),))),
//      );
//    }
      return  new Scaffold(
            drawer: this.getDrawer(),
            body: Builder(builder:(context){
              return getBody(context);
            }),
      );
  }


  Widget getBody(BuildContext context)
  {
    return new MoSliver(
      appBar: MoSliverAppBar(
        floating: true,
        snap: true,
        height: MoSliverAppBar.MO_BAR_HEIGHT + 50,
        leading: new IconButton(icon: Icon(Icons.reorder,color: Colors.black,), onPressed: (){
          Scaffold.of(context).openDrawer();
        }),
        flexibleSpace: getFlexibleSpace(),
      ),
      widgets: <Widget>[
        Test.VIEW_TESTS(context),
        Program.VIEW_PROGRAM(context),
      ],
    );
  }


  Widget getFlexibleSpace()
  {
    return FlexibleSpaceBar(
      // title: new Text(Helpers.cut10(widget.title),),
        background: SafeArea(

//                  child: Center(
            child: Padding(
              padding: EdgeInsets.only(left:paddingDescription-10,right:paddingDescription-10),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MoTexts.outLineText(MoColor.canvasColor, Colors.black, Helpers.cutN("Moction",9)),
                      new Text("This risk stratification tool is valid and reliable and highly effective when combined with a comprehensive protocol, and fall-prevention products and technologies ",
                            textAlign:TextAlign.center,style:
                            TextStyle(color:Colors.black54),),

                    ],
                  ),
              ),
            )));
  }



//  Widget getBody()
//  {
//    return Center(
//      child: new Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          new MoButton(
//            text:"Add new Test",
//            color: Colors.black,
//            onTap: (){
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> (MakeATest())));
//            },
//          ),
//          new MoButton(
//            text:"view Tests",
//            color: Colors.black,
//            onTap: (){
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowTests(Test.TESTS_START_TEST))));
//            },
//          ),
//          new MoButton(
//            text:"add a patient ",
//            color: Colors.black,
//            onTap: (){
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> (Patient_Sign_Up(
//                themeData: ThemeData(
//                  primaryColor: Theme.of(context).primaryColor
//                ),
//              ))));
//            },
//          ),
//          new MoButton(
//            text:"log out",
//            color: Colors.black,
//            onTap: (){
//              FirebaseAuth.instance.signOut().then((s){
//                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Auth()));
//                print("signed out");
//              });
//            },
//          ),
//          new MoButton(
//            text:"show all patients",
//            color: Colors.black,
//            onTap: (){
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowAllPatients(
//
//                themeData: ThemeData(
//                    primaryColor: Theme.of(context).primaryColor
//                ),
//              ))));
//            },
//          ),
//          new MoButton(
//            text: "make a program",
//            onTap: (){
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> (MakeAProgram(
//
//                themeData: ThemeData(
//                    primaryColor: Theme.of(context).primaryColor
//                ),
//              ))));
//            },
//          ),
//          new MoButton(
//            text: "show programs",
//            onTap: (){
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowPrograms(1))));
//            },
//          ),
//          new MoButton(
//            text: "make a pdf",
//            onTap: (){
//              String case1 = "case (3@1-50):\n3>=3|hello from the otherside\n4<5 and 2>1|this works break;";
//              String case2 = "case (1<2):\n 1=1|one is equal to one and less than two\n2>1|another case break;";
//              String logic = case1+"\n" + case2;
//              print(MoLogic.performLogic(new Map(), logic));
//            },
//          )
//        ],
//      ),
//    );
//  }


  Widget getDrawer ()
  {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          getDrawerHeader(),
          getDrawerTiles("Show All Patients", Patient.PATIENT,icon: Icons.people),
          getDrawerTiles("Add Patient", Patient.ADD_PATIENT,icon: Icons.person_add),
        ],
        padding: EdgeInsets.zero,
      ),
    );
  }




  Widget getDrawerHeader()
  {
    return Container(
      height: 450.0,
      child: DrawerHeader(
          child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                new Image(image: logo),
                new Text("Developed by Moh Yaghoub",)
              ],
            ),
          )),
          decoration: BoxDecoration(
              color: MoColor.canvasColor
          ),
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.all(0.0)
      ),
    );
  }




  Widget getDrawerTiles(String text,int mode,{IconData icon,String sub})
  {
    return new ListTile(
      onTap: ()=>onTap(mode),
      title: Text(text),
      leading: new Icon(icon,color: Colors.red,),
    );
  }

  onTap(int mode)
  {
    switch(mode)
    {
      case Patient.PATIENT:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (ShowAllPatients(
                themeData: ThemeData(
                    primaryColor: Theme.of(context).primaryColor
                ),
              ))));
        break;
      case Patient.ADD_PATIENT:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (Patient_Sign_Up(
                themeData: ThemeData(
                  primaryColor: Theme.of(context).primaryColor
                ),
              ))));
        break;
    }
  }

}

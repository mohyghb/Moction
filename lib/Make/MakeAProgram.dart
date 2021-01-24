import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:moction/Firebase_Helpers/MoFirebase.dart';
import 'package:moction/MoWidgets/MoTextFormField.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/DateConvertor/MoDateConvertor.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/Search/SearchATest.dart';
import 'package:moction/Test/Program.dart';
import 'package:moction/Loaded.dart';
import 'package:moction/Test/Test.dart';

class MakeAProgram extends StatefulWidget{

  ThemeData themeData;
  Program oldProgram;

  MakeAProgram({this.themeData,this.oldProgram});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MakeAProgramState();
  }


}

class MakeAProgramState extends State<MakeAProgram>{


  Program newProgram;

  MoTextFormField fullName;
  MoTextFormField description;
  MoTextFormField logic;


  //MoTextFormField status;

  /// test this out




  List<MoTextFormField> moWidgets;

  GlobalKey<FormState> _key = new GlobalKey();

  bool loading;

  @override
  void initState() {
    // TODO: implement initState


    super.initState();

    this.loading = false;
    this.newProgram = new Program();


    moWidgets = new List();
    fullName = MoTextFormFields.FULL_NAME_TEXT_FIELD();
    description = MoTextFormFields.makeDynamicField_RecRound(
      maxLines: 4,
      label: "Enter description",

    );

    logic = MoTextFormFields.makeDynamicField_RecRound(
      maxLines: 4,
      label: "Enter logic",

    );

    if(widget.oldProgram!=null){
      this.newProgram = widget.oldProgram;

      FirebaseDatabase.instance.reference().child(Program.PROGRAM_SUBS).child(this.newProgram.id).once().then((data){
        this.newProgram.toClass(data.value, Program.PROGRAM_SUBS,loadTagsForSubTests: true);
        setState(() {
          this.fullName.setText(this.newProgram.title);
          this.description.setText(this.newProgram.description);
          this.logic.setText(this.newProgram.logic);
        });
        print(this.newProgram.title);
        print(this.newProgram.description);
        print(this.newProgram.logic);
      });


    }


//    status = MoTextFormFields.makeDynamicField_RecRound(
//        hint: "Enter your working status",
//        label: "Status",
//        icon: Icons.work
//    );
//
//    status.suffixIcon = new DropdownButtonHideUnderline(child: DropdownButton(items: ["Working","Not working"].map((String s){
//      return new DropdownMenuItem(child: new Text(s), value: s,);
//    }).toList(), onChanged: (String s){
//      status.controller.text = s;
//      print(s);
//    }));



    moWidgets.add(fullName);
    moWidgets.add(description);
    moWidgets.add(logic);


    /// syncing focus nodes so that the textfields 'next' moves the cursor to the next item
    /// and if there is no next item, then it is going to perform 'onDone'
    //MoTextFormFields.syncFocusNodes(this.moWidgets, createNewPatient);








  }






  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if(this.loading){
      return new CircularProgressIndicator();
    }
    return Scaffold(
      body: Theme(
        data: MoNotNull.theme(widget.themeData, context),
        child: new MoSliver(
          padding: MoPaddingVersions.universal(),
          appBar: new MoSliverAppBar(
            pinned: true,
            flexTitle: "New Program",

          ),
          widgets: <Widget>[
            MoTextFormFields.getForm(_key, moWidgets),
            showSubs(),
            searchButton(),
            MoButton(
              text: "Create New Program",
              radius: 15.0,
              themeData: widget.themeData,
              onTap: createNewPatient,
            ),
          ],
        ),
      ),
    );
  }



  Widget showSubs()
  {
    if(this.newProgram.listOfTestIds!=null){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: this.newProgram.listOfTestIds.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return new Row(
                children: <Widget>[
                  Expanded(child: new Text(this.newProgram.listOfTestIds[index])),
                  removeButton(index),
                ],
              );
            }
        ),
      );
    }else{
      return SizedBox();
    }
  }


  Widget removeButton(int index)
  {
    return new MoButton(
      iconData: Icons.close,
      color: Colors.red,
      radius: 100.0,
      textColor: Colors.white,
      onTap: (){
        setState(() {
          this.newProgram.listOfTestIds.removeAt(index);
        });
      },
    );
  }

  Widget searchButton()
  {
    return new MoButton(
      iconData: Icons.search,
      color: Colors.red,
      radius: 100.0,
      textColor: Colors.white,
      onTap: search,
    );
  }

  search() async
  {
    setState(() {
      this.loading = true;
    });
    if(Loaded.tests.isEmpty){
      /// reload the tests only when
      /// the Loaded.tests are null
      /// or they pull down to refresh
      Loaded.tests = await MoFirebase.getTests(MoFirebase.getTestsBasicRef(),Test.TESTS_BASIC);
      print("loading tests");
    }
    this.loading = false;
    showSearch(context: context, delegate: SearchATest(Loaded.tests.values.toList(),Test.TESTS_RETURN_TEST)).then((test){
      this.newProgram.listOfTestIds.add(test.id);
    });
  }



  createNewPatient()
  {
      this.newProgram.title = this.fullName.getText();
      this.newProgram.description = this.description.getText();
      this.newProgram.logic = this.logic.getText();
      newProgram.date =  MoDateConvertor.getDateString(DateTime.now());

      print(newProgram.title);
      print(newProgram.description);
      print(newProgram.date);
      print(newProgram.logic);
      print(newProgram.listOfTestIds);



      if(this.newProgram.id==null){
        this.newProgram.addId();
      }
      print(newProgram.id);

      this.newProgram.update(Program.PROGRAM_BASIC);
      this.newProgram.update(Program.PROGRAM_SUBS);


      Navigator.pop(context);
  }




}
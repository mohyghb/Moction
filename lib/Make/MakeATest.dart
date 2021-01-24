

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:moction/Loaded.dart';
import 'package:moction/MoWidgets/MoTextFormField.dart';
import 'package:moction/Test/Test.dart';
import 'package:moction/Helpers.dart';

import 'package:moction/MoWidgets/MoButton.dart';

import 'package:moction/Test/SubTest.dart';
import 'package:moction/Make/MakeASubTest.dart';
import 'package:moction/Firebase_Helpers/MoFirebase.dart';

import 'package:moction/MoWidgets/MoDialog.dart';
import 'package:moction/Search/SearchASub.dart';



class MakeATest extends StatefulWidget
{

  Test test;
  MakeATest({this.test});



  @override
  _MakeATestState createState() => _MakeATestState();
}

class _MakeATestState extends State<MakeATest> {

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();

  Test newTest;
  List<SubTest> subs;

  List<String> listOfSubIds;

  MoTextFormField status;

  bool isChanging;
  bool loading;


  //initializer
  void initState()
  {
    initVars();
    super.initState();
  }

  //init all the vars
  void initVars() async
  {
    this.loading = false;

    status = MoTextFormFields.makeDynamicField_RecRound(
      label: "Status",
    );



    if(widget.test!=null){
      this.isChanging = true;

      widget.test.getSubsOfTest(loadTagsForSubTests:true,loadTags: true,).then((s){
        setState(() {
          this.newTest = widget.test;
          //this.subs = widget.test.subs;
          this.listOfSubIds = widget.test.listOfSubIds;
          print(widget.test.listOfSubIds.length.toString());
          this._nameController.text = widget.test.title;
          this._descriptionController.text = widget.test.description;
          this._codeController.text = widget.test.notParsedLogic;
          this.status.setText(widget.test.status.toString());
        });
      });

    }else{
      this.isChanging = false;
      this.subs = new List<SubTest>();
      this.listOfSubIds = new List();
      this.newTest = new Test();

    }

  }






  //produces the scaffold of the createAppointment
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: getAppBar("Create Test"),
      body: Builder(
          builder: (BuildContext context) {
            return getBody(context);
          }
      ),
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomPadding: true,
    );
  }


  Widget getAppBar(String text)
  {
    return new AppBar(
      elevation: 0.0,
      title: new Text(text),
      centerTitle: true,
      leading: new IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
        MoDialog.showMoDialog(
            context,
          content: new Text("Are you sure?"),
          actions: <Widget>[
            new FlatButton(onPressed: (){
          Navigator.pop(context);
          Navigator.pop(context);
        }, child: new Text("Leave")),
            new FlatButton(onPressed: (){
              Navigator.pop(context);
              createTest();
        } , child: new Text("save"))
          ]
        );
      }),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  //produce the appbar



  //produces the body of the manger
  Widget getBody(BuildContext context)
  {
    if(this.loading){
      return new CircularProgressIndicator();
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getTextFieldForName(),
                  getTextFieldForDescription(),
                  this.status,
                  getTFForLogic(),
                  showSubs(),
                  getSubTests(),
                //  getImageButton(context),
                  getButtonForNewHairJob(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  //get the name TextField
  Widget getTextFieldForName()
  {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right:8.0,top:8.0),
      child: new TextField(
        maxLines: 1,
        controller: this._nameController,
        enabled: true,
        obscureText: false,
        cursorColor: Theme.of(context).cursorColor,
        cursorWidth: 2,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: Helpers.FONT_SIZE
        ),
        decoration: new InputDecoration(
            icon: Icon(Icons.title,color: Colors.black,),
            hintText: "Title",
            labelText: "Enter a title",
            labelStyle: TextStyle(
                color: Colors.black
            ),
            hintStyle: TextStyle(
                fontSize: Helpers.FONT_SIZE)
        ),
      ),
    );
  }
  //set the name of HJ on change


  //get the description TextField
  Widget getTextFieldForDescription()
  {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right:8.0,bottom: 8.0),
      child: new TextField(
        keyboardType: TextInputType.multiline,
        controller: this._descriptionController,
        cursorColor: Theme.of(context).cursorColor,
        cursorWidth: 2,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: Helpers.FONT_SIZE
        ),
        maxLines: 6,
        decoration: new InputDecoration(

            hintText: "Description",
            icon: Icon(Icons.description,color: Colors.black,),

            labelText: "Write a description",
            labelStyle: TextStyle(
                color: Colors.black
            ),
            hasFloatingPlaceholder: true,
            hintStyle: TextStyle(
                fontSize: Helpers.FONT_SIZE)
        ),
      ),
    );
  }

  Widget showSubs()
  {
    if(this.listOfSubIds!=null){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: this.listOfSubIds.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return new Row(
                children: <Widget>[
                  Expanded(child: new Text(this.listOfSubIds[index])),
                  removeButton(index),
                  editButton(index),
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
          this.listOfSubIds.removeAt(index);
        });
      },
    );
  }

  Widget editButton(int index)
  {
    return new MoButton(
      iconData: Icons.edit,
      color: Colors.blue,
      radius: 100.0,
      textColor: Colors.white,
      onTap: (){
        SubTest sub = new SubTest("");
        sub.subId = this.listOfSubIds[index];
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (MakeASubTest("",this.listOfSubIds,subtest: sub,))));
      },
    );
  }



  Widget getSubTests()
  {
    return new PopupMenuButton<String>(
        onSelected: selectSubTest,
        child: Padding(
          padding: const EdgeInsets.only(left:8.0,top:8.0,right: 8.0),
          child: new MoButton(
            disabledColor: Colors.blue,
            iconData: Icons.add,
            textColor: Colors.white,
            radius: 20.0,
          ),
        ),
        itemBuilder: (BuildContext context) {
          return SubTest.TYPE_OF_SUB_TESTS.map((String m){
            return new PopupMenuItem<String>(
              value: m,
              child: new Text(m),
            );
          }).toList();
        });
  }


  selectSubTest(String subTest)
  {
    if(subTest == SubTest.CHOOSE_SUB_EXISTING){
      /// start the search;
      ///
      if(Loaded.subTests == null || Loaded.subTests.isEmpty) {
        setState(() {
          this.loading = true;
        });
        FirebaseDatabase.instance.reference().child(SubTest.SUBS).once().then((
            snap) {
          if (snap != null) {
            Map<dynamic, dynamic> map = snap.value;
            if (map != null) {
              map.forEach((dynamic key, dynamic value) {
                SubTest tool = new SubTest("");
                tool.toClass(value);
                Loaded.subTests.putIfAbsent(tool.subId, () => tool);
              });
            }
          }
          this.loading = false;
          showSearch(context: context,
              delegate: SearchASub(Loaded.subTests.values.toList())).then((
              SubTest tool) {
                if(tool!=null){
                  this.listOfSubIds.add(tool.subId);
                }

          });
        });
      }else {
        showSearch(context: context,
            delegate: SearchASub(Loaded.subTests.values.toList())).then((
            SubTest tool) {
          if(tool!=null){
            this.listOfSubIds.add(tool.subId);
          }
        });
      }
    }else{
      // launch make sub test
      Navigator.push(context, MaterialPageRoute(builder: (context)=> (MakeASubTest(subTest,this.listOfSubIds))));
    }


  }




  //get the description TextField
  Widget getTFForLogic()
  {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right:8.0,bottom: 8.0),
      child: new TextField(
        keyboardType: TextInputType.multiline,
        controller: this._codeController,
        cursorColor: Theme.of(context).cursorColor,
        cursorWidth: 2,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: Helpers.FONT_SIZE
        ),
        maxLines: 6,
        decoration: new InputDecoration(

            hintText: "Logic",
            icon: Icon(Icons.code,color: Colors.black,),

            labelText: "Write a Logic",
            labelStyle: TextStyle(
                color: Colors.black
            ),
            hasFloatingPlaceholder: true,
            hintStyle: TextStyle(
                fontSize: Helpers.FONT_SIZE)
        ),
      ),
    );
  }








  //create the button for createNewHairJob
  Widget getButtonForNewHairJob(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8.0),
      child: new MoButton(
        iconData: Icons.add,
        text: getTextForButton(),
        radius: 20.0,
        textColor: Colors.white,
        onTap: createTest,
      ),
    );
  }





  //gets the appropriate text for the button
  String getTextForButton()
  {
    if(this.isChanging!=null && !this.isChanging){
      return Helpers.CREATE;
    }else{
      return Helpers.EDIT;
    }
  }


  createTest() async
  {
    this.newTest.title = this._nameController.text;
    this.newTest.description = this._descriptionController.text;
    this.newTest.listOfSubIds = this.listOfSubIds;
    this.newTest.logic = this._codeController.text;
    this.newTest.status = int.parse(this.status.getText()!=null?this.status.getText():"1");

    if(!this.isChanging){
      this.newTest.addId();
    }

    MoFirebase.set(MoFirebase.getTestSubsRefWith(this.newTest.id), this.newTest.toJson(Test.TESTS_SUBS));
    MoFirebase.set(MoFirebase.getTestsBasicRefWith(this.newTest.id), this.newTest.toJson(Test.TESTS_BASIC));

    Navigator.pop(context);
  }













  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    this._nameController.dispose();
    this._descriptionController.dispose();
    this._codeController.dispose();
    super.dispose();
  }










}

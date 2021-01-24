import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moction/AppBar/Appbar.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:moction/MoWidgets/MoTextFormField.dart';

import 'package:moction/Helpers.dart';

import 'package:moction/MoWidgets/MoButton.dart';

import 'package:moction/Test/SubTest.dart';
import 'package:moction/Test/Tools.dart';

import 'package:moction/Make/MakeATool.dart';
import 'package:moction/Search/SearchATool.dart';
import 'package:moction/Loaded.dart';


class MakeASubTest extends StatefulWidget
{

  List<SubTest> listOfSubTest;
  List<String> listOfSubTestIds;
  SubTest subtest;
  final String TYPE_OF_SUB_TEST;

  MakeASubTest(this.TYPE_OF_SUB_TEST,this.listOfSubTestIds,{this.subtest});



  @override
  _MakeASubTestState createState() => _MakeASubTestState();
}

class _MakeASubTestState extends State<MakeASubTest> {

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();

  SubTest newSubTest;
  //List<Tools> listOfTools;

  List<String> listOfToolsId;


  //for picking an image or video


  bool isChanging;
  bool loadingToGetTools;


  int reorder;


  //initializer
  void initState()
  {

    initVars();
    super.initState();
  }

  //init all the vars
  void initVars()
  {
    this.loadingToGetTools = false;
    if(widget.subtest!=null){
      this.isChanging = true;

      widget.subtest.idToClass(widget.subtest.subId,loadTags: true).then((s){
        setState(() {
          this._nameController.text = widget.subtest.title;
          this._descriptionController.text = widget.subtest.description;
          this.newSubTest = widget.subtest;
          //this.listOfTools = widget.subtest.tools;
          this.listOfToolsId = widget.subtest.toolsId;
          this._codeController.text = widget.subtest.logic;

          this.newSubTest.subId = widget.subtest.subId;
          print("worked");
        });

      });


    }else{
      this.isChanging = false;
      this.newSubTest = new SubTest(widget.TYPE_OF_SUB_TEST);
      this.listOfToolsId = new List();
    //  this.listOfTools = new List<Tools>();
    }

  }






  //produces the scaffold of the createAppointment
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      appBar: getAppBar("Create "+ widget.TYPE_OF_SUB_TEST),
      body: Builder(
          builder: (BuildContext context) {
            return getBody(context);
          }
      ),
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomPadding: true,
    );
  }


  //produce the appbar
  Widget getAppBar(String text)
  {
    return new AppBar(
      elevation: 0.0,
      title: new Text(text),
      centerTitle: true,
     // leading: new IconButton(icon: Icon(Icons.arrow_back), onPressed: this.createSubTest),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }



  //produces the body of the manger
  Widget getBody(BuildContext context)
  {
    if(this.loadingToGetTools){
      return new Center(
        child: new CircularProgressIndicator(),
      );
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
                  getTFForLogic(),
                  showTools(),
                  getTools(),
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
      padding: const EdgeInsets.all(8.0),
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

  Widget showTools()
  {
    if(this.listOfToolsId!=null){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: this.listOfToolsId.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return new Row(
                children: <Widget>[
                  Expanded(child: GestureDetector(child: new Text(this.listOfToolsId[index]),
                      onTap: (){
                        print("triggered");
                        if(this.reorder == null){
                          this.reorder = index;
                        }else{
                          this.replace(this.reorder, index);
                          this.reorder = null;
                        }
                      })),
                  removeButton(index),
                  editButton(index)
                ],
              );
            }
        ),
      );
    }
    return SizedBox();

  }

  void replace(int first, int second)
  {
    List<String> newList = new List();
    String saveFirst = this.listOfToolsId[first];
    String saveSecond = this.listOfToolsId[second];
    for(int i = 0;i<this.listOfToolsId.length;i++){
      if(first==i){
        newList.add(saveSecond);
      }else if(second == i){
        newList.add(saveFirst);
      }else{
        newList.add(this.listOfToolsId[i]);
      }
    }

    setState(() {
      this.listOfToolsId = newList;
    });

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
          this.listOfToolsId.removeAt(index);
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
        Tools tool  = new  Tools("",null);
        tool.id = this.listOfToolsId[index];
        Navigator.push(context, MaterialPageRoute(builder: (context)=> (MakeATool("",this.listOfToolsId,tool: tool,))));
      },
    );
  }


  Widget getTools()
  {
    return new PopupMenuButton<String>(
        onSelected: selectTool,
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
          return Tools.TYPE_OF_TOOLS.map((String m){
            return new PopupMenuItem<String>(
              value: m,
              child: new Text(m),
            );
          }).toList();
        });
  }


  selectTool(String tool)
  {
    if(tool == Tools.CHOOSE_TOOL_EXISTING){
      ///launch a search bar over all the tools
      /// load them first and then pass it to that class
      ///

      if(Loaded.tools == null || Loaded.tools.isEmpty){
        setState(() {
          this.loadingToGetTools = true;
        });
        FirebaseDatabase.instance.reference().child(Tools.TOOLS).once().then((snap){

          if(snap!=null){
            Map<dynamic,dynamic> map = snap.value;
            if(map!=null){
              map.forEach((dynamic key, dynamic value){
                Tools tool = new Tools("","");
                tool.toClass(value);
                Loaded.tools.putIfAbsent(tool.id, ()=> tool);
              });
            }
          }

          this.loadingToGetTools = false;
          showSearch(context: context, delegate: SearchATool(Loaded.tools.values.toList())).then((Tools tool){
            if(tool!=null){
              this.listOfToolsId.add(tool.id);
            }

          });

        });
      }else{
        showSearch(context: context, delegate: SearchATool(Loaded.tools.values.toList())).then((Tools tool){
          if(tool!=null){
            this.listOfToolsId.add(tool.id);
          }
        });
      }

    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=> (MakeATool(tool,this.listOfToolsId))));
    }
    // launch make a tool

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
        onTap: createSubTest,
      ),
    );
  }


  //gets the appropriate text for the button
  String getTextForButton()
  {
    if(!this.isChanging){
      return Helpers.CREATE;
    }else{
      return Helpers.EDIT;
    }
  }


  void createSubTest()
  {
    if(this.isChanging){
      this.newSubTest.title = this._nameController.text;
      this.newSubTest.description = this._descriptionController.text;
      this.newSubTest.logic = this._codeController.text;

      Navigator.pop(context);
    }else{
   //   this.newSubTest.tools = this.listOfTools;
      this.newSubTest.title = this._nameController.text;
      this.newSubTest.description = this._descriptionController.text;
      this.newSubTest.logic = this._codeController.text;
      this.newSubTest.toolsId = this.listOfToolsId;

      this.newSubTest.makeNewId();

      widget.listOfSubTestIds.add(this.newSubTest.subId);

      Navigator.pop(context);
    }

    this.newSubTest.update();

  }












  @override
  void dispose() {

    this._nameController.dispose();
    this._descriptionController.dispose();
    this._codeController.dispose();
    super.dispose();
  }





















}

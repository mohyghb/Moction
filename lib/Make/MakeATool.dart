import 'dart:io';

import 'package:flutter/material.dart';


import 'package:moction/Helpers.dart';

import 'package:moction/MoWidgets/MoButton.dart';

import 'package:moction/Test/SubTest.dart';
import 'package:moction/Test/Tools.dart';

import 'package:moction/Test/Tools.dart';

import 'package:moction/Test/Button.dart';
import 'package:moction/Test/Checker.dart';
import 'package:moction/Test/Timer.dart';
import 'package:moction/Test/Score.dart';
import 'package:moction/Test/Range.dart';
import 'package:moction/Test/Data.dart';

import 'package:moction/MoWidgets/MoTextFormField.dart';

class MakeATool extends StatefulWidget
{

  List<Tools> listOfTools;
  List<String> listOfToolsId;
  Tools tool;
  final String TYPE_OF_TOOL;

  MakeATool(this.TYPE_OF_TOOL,this.listOfToolsId,{this.tool});



  @override
  _MakeAToolState createState() => _MakeAToolState();
}

class _MakeAToolState extends State<MakeATool> {

  final _nameController = TextEditingController();
  final _scoreController = TextEditingController();

  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _incrementController = TextEditingController();
  final _enterLogicData = MoTextFormFields.makeDynamicField_RecRound(
    maxLines: 6,
    hint: "Enter data",
    label: "Data"
  );

  Tools newTool;

  //for picking an image or video


  bool isChanging;




  //initializer
  void initState()
  {
    initVars();
    super.initState();
  }

  //init all the vars
  void initVars() async
  {



    if(widget.tool!=null){
      this.isChanging = true;

      this.newTool = new Tools("",null);
      await this.newTool.idToClass(this.widget.tool.id,state: updateValues);

    }else{
      this.isChanging = false;
      this.newTool = new Tools(widget.TYPE_OF_TOOL,0);
    }
  }

  updateValues()
  {
    setPreviousValues();
    setState(() {

    });
  }


  setPreviousValues()
  {
    this._nameController.text = this.newTool.tool.title;
    String type = "";
    if(this.isChanging){
      type = this.newTool.typeOfTool;
    }else{
      type = widget.TYPE_OF_TOOL;
    }

    switch(type){

      case Tools.BUTTON:
        print("worked");
        this._scoreController.text = this.newTool.tool.score;
        break;
      case Tools.CHECKER:
        this._scoreController.text = this.newTool.tool.score;
        break;
      case Tools.SCORE:
        this._startController.text = this.newTool.tool.range.start;
        this._endController.text = this.newTool.tool.range.end;
        this._incrementController.text = this.newTool.tool.range.increment;
        this._enterLogicData.controller.text = this.newTool.tool.data;
        break;
      case Tools.TIMER:
        break;
      case Tools.DATA:
        this._enterLogicData.controller.text = this.newTool.tool.data;
        break;
        /// add case for data here
      default:
        break;
    }
  }





  //produces the scaffold of the createAppointment
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: getAppBar("Create "+widget.TYPE_OF_TOOL),
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
//      leading: new IconButton(icon: Icon(Icons.arrow_back), onPressed: this.createTool),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }


  //produces the body of the manger
  Widget getBody(BuildContext context)
  {
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
                children: getListOfWidgets(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getListOfWidgets(BuildContext context)
  {
    List<Widget> widgets = new List<Widget>();
    widgets.add(getTextFieldForName());
    String type = "";
    if(this.isChanging){
      type = this.newTool.typeOfTool;
    }else{
      type = widget.TYPE_OF_TOOL;
    }
    switch(type){

      case Tools.BUTTON:
        widgets.add(getTextFieldForScore());
        break;
      case Tools.CHECKER:
        widgets.add(getTextFieldForScore());
        break;
      case Tools.SCORE:
        widgets.add(range());
        widgets.add(this._enterLogicData);
        //add range
        break;
      case Tools.TIMER:

        break;
      case Tools.DATA:
        widgets.add(this._enterLogicData);
        widgets.add( new DropdownButtonHideUnderline(child: DropdownButton(items: DataConstants.allPossibilities().map((String s){
          return new DropdownMenuItem(child: new Text(s), value: s,);
        }).toList(), onChanged: (String s){
          _enterLogicData.controller.text += "\n"+s;

        })));
        break;
      default:
        break;
    }

    widgets.add(createButton(context));

    return widgets;
  }

  Widget range()
  {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Row(
          children: <Widget>[
            Expanded(child: startTF()),
            Expanded(child: endTF())
          ],
        ),
        incTF()
      ],
    );
  }

  Widget startTF()
  {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right:8.0,top:8.0),
      child: new TextField(
        //!!! is not working (negative and decimal not working when set to false)
        keyboardType: TextInputType.numberWithOptions(
            decimal: false,
            signed: false),
        maxLines: 1,
        controller: this._startController,
        enabled: true,
        obscureText: false,
        cursorColor: Theme.of(context).cursorColor,
        cursorWidth: 2,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: Helpers.FONT_SIZE
        ),

        autofocus: false,
        decoration: new InputDecoration(
            icon: Icon(Icons.score),
            labelText: "Start of score",
            hintText: "Start",
            hintStyle: TextStyle(
                fontSize: Helpers.FONT_SIZE)
        ),
      ),
    );
  }


  Widget endTF()
  {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right:8.0,top:8.0),
      child: new TextField(
        //!!! is not working (negative and decimal not working when set to false)
        keyboardType: TextInputType.numberWithOptions(
            decimal: false,
            signed: false),
        maxLines: 1,
        controller: this._endController,
        enabled: true,
        obscureText: false,
        cursorColor: Theme.of(context).cursorColor,
        cursorWidth: 2,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: Helpers.FONT_SIZE
        ),

        autofocus: false,
        decoration: new InputDecoration(
            icon: Icon(Icons.score),
            labelText: "End of score",
            hintText: "End",
            hintStyle: TextStyle(
                fontSize: Helpers.FONT_SIZE)
        ),
      ),
    );
  }


  Widget incTF()
  {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right:8.0,top:8.0),
      child: new TextField(
        //!!! is not working (negative and decimal not working when set to false)
        keyboardType: TextInputType.numberWithOptions(
            decimal: false,
            signed: false),
        maxLines: 1,
        controller: this._incrementController,
        enabled: true,
        obscureText: false,
        cursorColor: Theme.of(context).cursorColor,
        cursorWidth: 2,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: Helpers.FONT_SIZE
        ),

        autofocus: false,
        decoration: new InputDecoration(
            icon: Icon(Icons.score),
            labelText: "Increment of score",
            hintText: "Increment",
            hintStyle: TextStyle(
                fontSize: Helpers.FONT_SIZE)
        ),
      ),
    );
  }


  Widget getTextFieldForScore()
  {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right:8.0,top:8.0),
      child: new TextField(
        //!!! is not working (negative and decimal not working when set to false)
        keyboardType: TextInputType.numberWithOptions(
            decimal: false,
            signed: false),
        maxLines: 1,
        controller: this._scoreController,
        enabled: true,
        obscureText: false,
        cursorColor: Theme.of(context).cursorColor,
        cursorWidth: 2,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: Helpers.FONT_SIZE
        ),

        autofocus: false,
        decoration: new InputDecoration(
            icon: Icon(Icons.timelapse),
            labelText: "Score of this checker",
            hintText: "Score",
            hintStyle: TextStyle(
                fontSize: Helpers.FONT_SIZE)
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




  //create the button for createNewHairJob
  Widget createButton(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8.0),
      child: new MoButton(
        iconData: Icons.add,
        text: getTextForButton(),
        radius: 20.0,
        textColor: Colors.white,
        onTap: createTool,
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


  void createTool()
  {
    if(this.isChanging){
      newTool.tool = getTool();
      Navigator.pop(context);
    }else{
      newTool.tool = getTool();
      /// here we add the new tools id
      //widget.listOfTools.add(newTool);
      newTool.addId();
      widget.listOfToolsId.add(newTool.id);

      Navigator.pop(context);
    }

    /// updating the new tool
    /// also we wanna pass its id to the sub test
    print(newTool.id);
    print(newTool.tool);
    newTool.update();
  }



  getTool()
  {
    String title = this._nameController.text;
    String score = this._scoreController.text;
    String data = this._enterLogicData.getText();
    Range range = new Range(this._startController.text,this._endController.text,this._incrementController.text);

    String type = "";
    if(this.isChanging){
      type = this.newTool.typeOfTool;
    }else{
      type = widget.TYPE_OF_TOOL;
    }


    switch(type){
      case Tools.BUTTON:
        Button button = new Button(title, score);
        return button;
        break;
      case Tools.CHECKER:
        Checker checker = new Checker(title, score);
        return checker;
        break;
      case Tools.SCORE:
        Score score = new Score(title,range,data);
        return score;
        break;
      case Tools.TIMER:
        Timer timer = new Timer(title);
        return timer;
        break;

      case Tools.DATA:
        Data dataClass = new Data(data,title);
        return dataClass;
        break;
      case Tools.INPUT:
        Timer timer = new Timer(title);
        return timer;
        break;
      default:
        break;
    }
  }














  @override
  void dispose() {

    this._nameController.dispose();
    this._scoreController.dispose();
    this._startController.dispose();
    this._endController.dispose();
    this._incrementController.dispose();

    super.dispose();
  }





















}

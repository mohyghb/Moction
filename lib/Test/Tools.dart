import 'package:flutter/material.dart';
import 'package:moction/Helpers.dart';
import 'package:moction/Show/ShowAProgram.dart';
import 'package:moction/Test/Button.dart';
import 'package:moction/Test/Checker.dart';
import 'package:moction/Test/Data.dart';
import 'package:moction/Test/HelpMenu.dart';
import 'package:moction/MoWidgets/MoId.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:moction/Test/Range.dart';
import 'package:moction/Test/Score.dart';
import 'package:moction/Test/Timer.dart';
import 'package:moction/MoWidgets/MoExpandablePanel.dart';
import 'package:moction/MoWidgets/MoButton.dart';


import 'package:moction/MoStopWatch/FormatTime.dart';
import 'package:moction/MoWidgets/MoStopWatch.dart';
import 'package:moction/ReactionTime/PlayReactionTime.dart';

import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/MoWidgets/MoChecker.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/MoWidgets/MoTextField.dart';
import 'package:moction/MoWidgets/MoCard.dart';

import 'package:moction/Show/ShowATest.dart';


class Tools extends HelpMenu{

  static const String RESULTS = "Results";
  static const String TOOLS = "TOOLS";

  //for questionnaire
  static const BUTTON = "BUTTON";
  static const CHECKER = "CHECKER";

  //for normal
  static const TIMER = "TIMER";
  static const SCORE = "SCORE";

  static const INPUT = "INPUT";

  //for reaction time
  static const String DATA = "DATA";
  static const String TITLE = "TITLE";



  static const String CHOOSE_TOOL_EXISTING =  "CHOOSE_TOOL_EXISTING";


  static const TYPE_OF_TOOLS = [BUTTON,CHECKER,TIMER,SCORE,DATA,INPUT,CHOOSE_TOOL_EXISTING];


  /// different types of widget
  static const String WIDGET_SUB_TEST = "WIDGET_SUB_TEST";
  static const String WIDGET_SEARCH = "WIDGET_SEARCH";



  static const double spaceBetweenTI = 4.0;
  static const double radius = 50.0;
  static const double elevation = 10.0;


  String _typeOfTool;
  dynamic _tool;

  String _id;
  bool isDoneLoading;


  Tools(this._typeOfTool,this._tool){
    this.isDoneLoading = false;
  }


  String get typeOfTool => _typeOfTool;

  addId()
  {
    this._id = MoId.generateRandomId(unique: this.typeOfTool);
  }


  String get id => _id;

  set id(String value) {
    _id = value;
  }

  set typeOfTool(String value) {
    _typeOfTool = value;
  }

  dynamic get tool => _tool;

  set tool(dynamic value) {
    _tool = value;
  }


  void restart()
  {
    this.tool.restart();
    this.notes = "";
  }


  bool disabled()
  {
    return ShowATest.result!=null || ShowAProgram.result!=null;
  }

  //Widgets

  Widget getEditingWidget()
  {
    return new Text(this._typeOfTool);
  }

  Widget toWidget({VoidCallback onTap, String type, Color themeColor, Color textColor, BuildContext context, VoidCallback refresh,List<Tools> tools})
  {
    if(type==null){
      return this.searchWidget(onTap);
    }else{

      switch(type){
        case Tools.WIDGET_SEARCH:
          return this.searchWidget(onTap);
          break;
        case Tools.WIDGET_SUB_TEST:
          return AnimatedOpacity(
            opacity: this.isDoneLoading?1.0:0.0,
            duration: Duration(milliseconds: 250),
              child: this.subWidget(themeColor, textColor, context, refresh, tools)
          );
          break;
        default:
          return this.searchWidget(onTap);
          break;
      }


    }

  }




  Widget searchWidget(VoidCallback onTap)
  {
    return MoButton(
      radius: 15.0,
      onTap: onTap,
      color: Colors.grey,
      child: this.tool.toWidget(),
    );
  }

  Widget subWidget(Color themeColor,Color textColor, BuildContext context, VoidCallback refresh, List<Tools> tools)
  {
    if(MoNotNull.string(this.notes).isNotEmpty){
      return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          this.getWidgetForTool(this, themeColor, textColor, context, refresh, tools),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: new Text("Note: "+this.notes),
          ),
        ],
      );
    }
    return this.getWidgetForTool(this, themeColor, textColor, context, refresh, tools);
  }


  String toSearch()
  {
    return this.typeOfTool.toLowerCase() + " " + this.tool.toSearch();
  }



  update()
  {
    if(this.id!=null){
      FirebaseDatabase.instance.reference().child(TOOLS).child(this.id).update(this.toJson());
    }

  }



  ///json
  toJson(){
    return {
      Helpers.TYPE : this.typeOfTool,
      Helpers.TOOL : this.tool.toJson(),
      HelpMenu.NOTE:  super.notes,
      Helpers.ID:  this._id
    };
  }

  toClass(dynamic data,{VoidCallback refresh, bool loadTools}){
    try{
      this._typeOfTool = data[Helpers.TYPE];
      this.tool = getToolBasedOn(this.typeOfTool);

      this.tool.toClass(data[Helpers.TOOL]);
      this.notes = data[HelpMenu.NOTE];


      this._id = data[Helpers.ID];


      //print("happeend");

      this.isDoneLoading = true;
      if(refresh!=null){
        refresh();
      }
    }catch(e){
      this.isDoneLoading = true;
      print("tool problems "+ e.toString());
    }

  }

  toResult()
  {
    return {
      HelpMenu.NOTE:  super.notes,
      RESULTS: this.tool.toResult()
    };

  }

  toClassFromResult(dynamic data)
  {
    this.notes = data[HelpMenu.NOTE];
    this.tool.toClassFromResult(data[RESULTS]);
  }


  getToolBasedOn(String type)
  {
    switch(type)
    {
      case Tools.TIMER:
        return new Timer("");
        break;
      case Tools.INPUT:
        return new Timer("");
        break;
      case Tools.SCORE:
        return new Score("",new Range("", "", ""),"");
        break;
      case Tools.BUTTON:
        return new Button("","");
        break;
      case Tools.CHECKER:
        return new Checker("","");
        break;
      case Tools.DATA:
        return new Data("","");
        break;
      default:

        break;
    }
  }


  /// call backs for button, checker, score, and timer
  void callBackForButton(Tools tool,VoidCallback refresh,List<Tools> tools)
  {
    // disable all other buttons
    // and add the score to this score

    for(int i = 0;i<tools.length;i++){
      if(tools[i].typeOfTool==Tools.BUTTON){
        // widget.tools[i].tool.deleted = true;
        tools[i].tool.wasPressed = false;
      }
    }
    tool.tool.wasPressed = true;
    refresh();
  }

  void callBackForChecker(bool b,Tools tool,VoidCallback refresh)
  {
      tool.tool.wasPressed = b;
      refresh();
  }

  void callBackForTimer(BuildContext context, Tools tool,Color themeColor,Color textColor)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> (MoStopWatch(tool,
      new ThemeData(
        primaryColor: themeColor,
        accentColor: textColor
      ),))));
  }

  void callBackForScore(String value,Tools tool,VoidCallback refresh)
  {

      tool.tool.title = value;
      refresh();
  }




  Widget getWidgetForTool(
      Tools tool,
      Color themeColor,
      Color textColor,
      BuildContext context,
      VoidCallback refresh,
      List<Tools> tools,
      )
  {
    switch(tool.typeOfTool){
      case Tools.BUTTON:
        if(tool.tool.wasPressed){
          return new MoButton(
            textColor: themeColor,
            text: tool.tool.title,
            radius: radius,
            iconData: Icons.radio_button_checked,
            spaceBetweenTI: spaceBetweenTI,
            color: Colors.black,
            onTap: MoButtons.getDisabledOnTap(disabled(), (){callBackForButton(tool, refresh,tools);}),
          );
        }
        return new MoButton(
          textColor: textColor,
          text: tool.tool.title,
          radius: radius,

          color: themeColor,
          iconData: Icons.radio_button_unchecked,
          spaceBetweenTI: spaceBetweenTI,
          splashColor: Colors.black,
          onTap: MoButtons.getDisabledOnTap(disabled(), (){callBackForButton(tool, refresh,tools);}),
        );
        break;

      case Tools.CHECKER:

       return  MoChecker(
         whenFalseColor: themeColor,
         whenTrueColor: Colors.black,
         value: tool.tool.wasPressed,
         radius: radius,
         disabled: disabled(),
         padding: MoPadding(
           paddingAll: 6.0
         ),
         childPadding: MoPadding(
           paddingAll: 15.0
         ),
         width: double.infinity,
         whenTrueBody: MoTexts.simpleText(context, tool.tool.title, Icons.check_box,
             color: themeColor,
             space: spaceBetweenTI,
             maa: MainAxisAlignment.center,
             align: TextAlign.center),

         whenFalseBody: MoTexts.simpleText(context, tool.tool.title, Icons.check_box_outline_blank,
             color: textColor,
             space: spaceBetweenTI,
             maa: MainAxisAlignment.center,
             align: TextAlign.center),

         onValueChanged: (b){
           callBackForChecker(b,tool,refresh);
         },
       );

//        return Row(
//          children: <Widget>[
//            new Checkbox(
//                value: tool.tool.wasPressed,
//                onChanged: (bool){
//
//                    callBackForChecker(bool,tool,refresh);
//                }
//            ),
//            new Text(tool.tool.title),
//          ],
//        );


        break;
      case Tools.SCORE:
        return getWidgetForScore(tool,refresh,themeColor,textColor);
        break;
      case Tools.TIMER:
        return new MoButton(
          textColor: textColor,
          text: FormatTime.readableForm(tool.tool.title),
          iconData: Icons.timer,
          spaceBetweenTI: spaceBetweenTI,
          radius: radius,
          color: themeColor,
          elevation: 10.0,
          onTap: MoButtons.getDisabledOnTap(disabled(), (){callBackForTimer(context,tool,themeColor,textColor);}),
        );
        break;
      case Tools.INPUT:
        return MoCard(
          backgroundColor: themeColor,
          cardRadius: MoCard.ROUND_REC_RADIUS,
          elevation: 10.0,
          childPadding: MoPadding(
            paddingAll: 16
          ),

          child: new MoTextField(
            themeData: ThemeData(
              primaryColor: Colors.black,
              cursorColor: Colors.black,
            ),
            keyBoardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: true
            ),
            text: tool.tool.getRightTitle(),
            onValueChanged: (String s){
              if(!disabled()){
                tool.tool.title = s;
              }
            },
            cursorColor: Colors.black,
            labelText: tool.tool.hintTitle,
            hasRoundBorders: true,
            iconData: Icons.straighten,
          ),
        );
        break;

      case Tools.DATA:
        return Column(
          children: <Widget>[
            new MoButton(
              textColor: textColor,
              text: tool.tool.title,
              iconData: Icons.filter_b_and_w,
              elevation: elevation,
              spaceBetweenTI: spaceBetweenTI,
              radius: radius,
              color: themeColor,
              onTap: MoButtons.getDisabledOnTap(disabled(), (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> (PlayReactionTime(tool.tool.reactionTime))));
              }),
            ),
            this.tool.getReactionWidget(context,refresh)
          ],
        );
        break;
      default:
        return new SizedBox();
        break;
    }
  }



  Widget getWidgetForScore(Tools tool, VoidCallback refresh,Color themeColor, Color textColor)
  {

    return new MoExpandablePanel(

      MoTexts.outLineText(themeColor, textColor, tool.tool.showTitle(),font: 40,letterSpacing: 3),

      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(tool.tool.gradeInfo(),style: TextStyle(color: textColor,),),
          ),
          tool.tool.getRangeWidget(refresh,themeColor,textColor,disabled()),


        ],
      ),
      isExpanded: false,
      duration: Duration(milliseconds: 400),
      themeData: ThemeData(cardColor: themeColor,accentColor: textColor),
      padding: MoPaddingVersions.universal(),
      elevation: 10.0,
    );

//
  }



  idToClass(String id,{VoidCallback state, bool loadTools}) async
  {
    await FirebaseDatabase.instance.reference().child(TOOLS).child(id).once().then((data){
      if(data!=null){
        this.toClass(data.value,refresh: state, loadTools: loadTools);
      }
    });
  }

  /// data is a map<String, String>
  static Future<List<Tools>> dataToListTools(dynamic data,{VoidCallback state}) async
  {
    List<Tools> tools = new List();

    if(data!=null){
      Map<dynamic,dynamic> map = data;
      if(map!=null) {
        /// value is the id of the tool
        /// so we need to read the class
        /// from the database
        map.forEach((dynamic key, dynamic value) {
          Tools tool = new Tools("", "");
          tool.idToClass(value,state: state);
          tools.add(tool);
        });
      }
    }
   return tools;
  }






}
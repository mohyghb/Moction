import 'package:moction/Test/Data.dart';
import 'package:flutter/material.dart';
import 'package:moction/ReactionTime/ChoiceButton.dart';
import 'package:moction/ReactionTime/Content.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/ReactionTime/Elapsed.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoPadding.dart';

class TypeTest{

  static const DEFAULT = DataConstants.SIMPLE;

  String _type;

  List<ChoiceButton> _choices;
  Content _content;

  TypeTest(String type){
    this._type = type.trim();
  }


  String get type => _type;

  set type(String value) {
    _type = value;
  }

  init()
  {
    this._choices = new List();
    if(this._type == DataConstants.CHOICE){
      /// it's a choice reaction time
      /// add buttons for that specified test

      ChoiceButton A = new ChoiceButton(this.content.getARandomContent(),"A");
      A.setOnTap(()=>onTapForChoice(A));
      ChoiceButton B = new ChoiceButton(this.content.getARandomContent(except: A.content),"B");
      B.setOnTap(()=>onTapForChoice(B));


      this.choices.add(A);
      this.choices.add(B);

    }else if(this.type == DataConstants.SIMPLE){
      ChoiceButton tapOnChange = new ChoiceButton("","A");
      tapOnChange.setOnTap(()=> onTapForSimple(tapOnChange));
      this.choices.add(tapOnChange);
    }
  }

  onTapForChoice(ChoiceButton choice)
  {
    if(!choice.isActive){
      makeElapse(Elapsed.TAPPED_MORE_THAN_ONCE);
      //print("its deactive");
    }
    else if(choice.isActive && choice.content==this.content.latestUpdate){
      makeElapse(Elapsed.CORRECT);
     // print(choice.name + " was pressed correctly");
      choice.deactivate();
    }else{
      // the answer is wrong
      makeElapse(Elapsed.WRONG);
      //print(choice.name +"  was pressed at the wrong time");
      choice.deactivate();
    }
  }

  onTapForSimple(ChoiceButton choice)
  {
    if(choice.isActive){
      /// record the time
      makeElapse(Elapsed.CORRECT);
      choice.deactivate();
      print("tapped right");
    }else{
      /// it is deactive
      /// they should not have tapped
      /// tapped more than once for elapsed
      makeElapse(Elapsed.TAPPED_MORE_THAN_ONCE);
      print("tapped wrong , more than once ");
    }
  }


  /// test this

  makeElapse(String status)
  {
    DateTime current = DateTime.now();
    Elapsed elapsed = new Elapsed(current.difference(this.content.latestUpdateTime), status);
  //  print(elapsed.status + ": " + (elapsed.reactionTime.inMilliseconds/1000).toString());
    this.content.reactionsTimes.add(elapsed);
  }



  /// checks to see whether the user has skipped one of the choice or not
  ///
  /// should be called before the reactivation of choice buttons
  checkSkip()
  {
//    if(this._type == DataConstants.CHOICE){
//      for(int i = 0;i<this.choices.length;i++){
//        if(this.choices[i].isActive && this.choices[i].content==this.content.latestUpdate){
//          /// they did not press it and skipped it
//          makeElapse(Elapsed.MISSED_ONE);
//        }
//      }
//    }
  }



  static const String INSTRUCTION_SIMPLE = "Tap on the screen when you see a ";

  Widget getInstructionsText(Color c,double fontSize)
  {
    if(this.isSimple()){
      return new Text(INSTRUCTION_SIMPLE + this.content.typeOfContent + " change.",textAlign: TextAlign.center,style: TextStyle(color: c,fontSize: fontSize));
    }else if(this.isChoice()){
      List<TextSpan> textSpans = new List();

      textSpans.add(MoTexts.easyTextSpan("Press ",color: c,fontSize: fontSize));
  //choiceButton.content
      int index = 0;
      for(ChoiceButton choiceButton in this.choices){
        textSpans.add(MoTexts.easyTextSpan("'${choiceButton.name}' when you see ",color: c,fontSize: fontSize));
        textSpans.add(MoTexts.easyTextSpan(choiceButton.content,color:choiceButton.getLabelColor(),isBold: true,fontSize: fontSize));
        if(index!=this.choices.length-1){
          textSpans.add(MoTexts.easyTextSpan(" and ",color: c,fontSize: fontSize));
        }
        index++;
      }
      return RichText(
          text: TextSpan(
               children: textSpans 
           ),
      );
    }else{
      return SizedBox();
    }
  }

  Widget getInstructions()
  {
    return MoCard(
      childPadding: MoPadding(
        paddingAll: 16.0
      ),
      padding: MoPadding(
        paddingAll: 8.0
      ),
      cardRadius: MoCard.ROUND_REC_RADIUS,
      child: this.getInstructionsText(Colors.black,30),
    );
  }


  List<Widget> getAllChoiceButtons()
  {
    List<Widget> list = new List();
    for(ChoiceButton choiceButton in this.choices){
      list.add(Expanded(child: choiceButton.button));
    }
    return list;
  }



  activateAllChoices(bool isFirst)
  {
    bool skipped = true;
    bool skippedChoice = false;
    for(ChoiceButton choiceButton in this.choices){
      if(choiceButton.isActive && choiceButton.content == content.latestUpdate){
        /// they have missed a choice button
        /// that they should have pressed
        skippedChoice = true;
      }
      if(!choiceButton.isActive){
        /// they have pressed something so they did not miss anything
        skipped = false;
      }
      choiceButton.activate();
    }

    if(skipped && !isFirst && this.type == DataConstants.SIMPLE){
      /// add a elapsed
      makeElapse(Elapsed.MISSED_ONE);
      print(Elapsed.MISSED_ONE);
    }
    if(this.type == DataConstants.CHOICE && skippedChoice && !isFirst){
      makeElapse(Elapsed.MISSED_ONE);
      print(Elapsed.MISSED_ONE + "choice version");
    }


  }




  List<ChoiceButton> get choices => _choices;

  set choices(List<ChoiceButton> value) {
    _choices = value;
  }

  Content get content => _content;

  set content(Content value) {
    _content = value;
    //print(this.content.typeOfContent);
  }


  bool isSimple()
  {
    return this.type== DataConstants.SIMPLE;
  }

  bool isChoice()
  {
    return this.type== DataConstants.CHOICE;
  }

}
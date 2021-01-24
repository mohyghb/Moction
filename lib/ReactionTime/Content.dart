import 'package:flutter/material.dart';
import 'package:moction/Test/Data.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoRandom.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/ReactionTime/TypeTest.dart';
import 'package:moction/ReactionTime/Elapsed.dart';
import 'package:moction/MoWidgets/MoTexts.dart';


class Content
{
  static const DEFAULT = DataConstants.COLOR;
  static const int MAX_NUMBER = 100;


  String _typeOfContent;


  Color color;
  List<String> hasToShowTheseColors;

  String number;
  List<String> hasToShowTheseNumbers;

  String latestUpdate;
  DateTime latestUpdateTime;


  List<Elapsed> reactionsTimes;

  TypeTest _type;


  Content(this._typeOfContent){
    this.hasToShowTheseColors = new List();
    this.hasToShowTheseNumbers = new List();
    this.reactionsTimes = new List();
    this.typeOfContent = this.typeOfContent.trim();
    updateContent();
  }


  TypeTest get type => _type;

  set type(TypeTest value) {
    _type = value;
   // print(type.type);
  }

  updateContent()
  {
    switch(this.typeOfContent){
      case DataConstants.MIX:
        updateMix();
        break;
      case DataConstants.COLOR:
        updateColor();
        break;
      case DataConstants.NUMBERS:
        updateNumber();
        break;
    }
    this.latestUpdateTime = DateTime.now();
  }

  updateMix()
  {
    int coin = MoRandom.random.nextInt(2);
    if(coin==1){
      this.updateNumber();
    }else{
      this.updateColor();
    }
  }

  updateColor()
  {

   // this.color = MoColor.randomDarkColor(except: this.color);

    int coin = MoRandom.random.nextInt(this.hasToShowTheseColors.length+1);
    if(coin==this.hasToShowTheseColors.length || this.hasToShowTheseColors[coin]==this.latestUpdate){
      ///show a random color
      List<dynamic> map = MoColor.randomDarkColorMap(exceptColor: this.color);
      this.color = map[1];
      this.latestUpdate = map[0];
    }else{

      /// show one of the has to show colors
      this.color = MoColor.darkColors[this.hasToShowTheseColors[coin]];
      this.latestUpdate = this.hasToShowTheseColors[coin];
      print("forced colors" + latestUpdate);
    }

  }



  updateNumber()
  {

    int size = this.hasToShowTheseNumbers.length;
    int coin = MoRandom.random.nextInt(size+1);
    if(coin == size || this.hasToShowTheseNumbers[coin] == this.latestUpdate){
      this.number = MoRandom.random.nextInt(MAX_NUMBER).toString();
    }else{
      this.number = this.hasToShowTheseNumbers[coin];
      print("forced number " + this.number);
    }

    this.latestUpdate = this.number.toString();
  }


  Widget toWidget(BuildContext context,{ThemeData data}) {
    // print(this.typeOfContent);
    // print("drawn again");
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        getAnimatedContainer(context,data:data),
        getChoiceButtons()
      ],
    );
  }

  Widget getChoiceButtons()
  {
    if(this.type.isChoice()){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: this.type.getAllChoiceButtons(),
        ),
      );
    }
    return SizedBox();

  }

  Widget getAnimatedContainer(BuildContext context,{ThemeData data})
  {
    if(this.type.isSimple()){

      return Material(
        color: MoNotNull.color(this.color,returnThis: MoNotNull.theme(data, context).primaryColor),
        child: InkWell(
            highlightColor: Colors.transparent,
          onTap: this.type.choices[0].getOnTap(),
          splashColor: Colors.white,
          child: new Container(
            child: Center(
                child: new Text(getNumber(),style: TextStyle(color: Colors.white, fontSize: 60.0),)
            ),
          ),
        ),
      );
    }
    else if(type.isChoice()){
      return new AnimatedContainer(
        color: MoNotNull.color(this.color,returnThis: MoNotNull.theme(data, context).primaryColor),
        duration: Duration(milliseconds: 0),
        child: Center(
            child: new Text(getNumber(),style: TextStyle(color: Colors.white, fontSize: 60.0),)
        ),
      );
    }else{
      return SizedBox();
    }

  }


  Widget showResults(BuildContext context,VoidCallback refresh)
  {
    if(reactionsTimes.isEmpty){
      return SizedBox();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: this.reactionsTimes.length,
              itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                confirmDismiss: (DismissDirection direction){
                  this.reactionsTimes.removeAt(index);
                  refresh();
                },
                key: Key(index.toString()),
                  onDismissed: (DismissDirection direction){

                  },
                  child: this.reactionsTimes[index].toWidget(context)
              );
              }),
        ),
        new Text(ElapsedFunctions.getAverageMilliSeconds(this.reactionsTimes)[1].toString()),
      ],
    );
  }


  List<Widget> getReactionTimesWidgets(BuildContext context,VoidCallback refresh)
  {

    List<Widget> ws = new List();
    if(this.reactionsTimes.isEmpty){
      return ws;
    }
    ws.add(MoTexts.titleText(context, "Results", Colors.white));
    ws.add(new Text("It is critical to know that, only reaction times with status ${Elapsed.CORRECT} are considered in the average value.",textAlign: TextAlign.center,));



    for(int index = 0;index<this.reactionsTimes.length;index++){
      ws.add(this.reactionsTimes[index].toWidget(context));
    }

    ws.add(MoTexts.titleText(
      context,
      "",
      Colors.white,
      fontSize: 20,
      align: TextAlign.center,
      bold: "Average: "+ (ElapsedFunctions.getAverageMilliSeconds(this.reactionsTimes)[1]/1000).toStringAsFixed(3) + " seconds",
    ));

    return ws;
  }



  String getNumber()
  {
    if(this.number!=null){
      return this.number;
    }else{
      return "";
    }
  }

  void resetNumber()
  {
    this.number = "";
  }



  String get typeOfContent => _typeOfContent;

  set typeOfContent(String value) {
    _typeOfContent = value;
  }


  /// returns true if the type of the content is COLOR
  bool isContentColor()
  {
    return this.typeOfContent == DataConstants.COLOR;
  }

  /// returns true if the type of the content is NUMBER
  bool isContentNumber()
  {
    return this.typeOfContent == DataConstants.NUMBERS;
  }

  /// returns true if the type of the content is MIX
  bool isContentMix()
  {
    return this.typeOfContent == DataConstants.MIX;
  }



  /// produces a random name of a number or a color based on the type of the content
  /// and adds it to the must produce
  String getARandomContent({String except}){
    if(this.isContentColor()){
      /// return a name of a color
      /// that is not same as except
      return randomColorName(except: except);
    }else if(this.isContentNumber()){
      /// return a  number.toString() that is not same as except
      ///
      return randomStringNumber(except: except);
    }else{
      /// return either a color or number based on a coin flip
      ///
      int coin = MoRandom.random.nextInt(2);
      if(coin==1){
        return this.randomColorName();
      }else{
        return this.randomStringNumber();
      }
    }
  }

  String randomColorName({String except})
  {
    List<dynamic> map = MoColor.randomDarkColorMap(except: except);
    this.hasToShowTheseColors.add(map[0]);
    return map[0];
  }

  String randomStringNumber({String except})
  {
    int rNumber = MoRandom.random.nextInt(MAX_NUMBER);
    String sNumber =  rNumber.toString();
    while(sNumber == except){
      rNumber = MoRandom.random.nextInt(MAX_NUMBER);
      sNumber =  rNumber.toString();
    }
    this.hasToShowTheseNumbers.add(sNumber);
    return sNumber;
  }





  String getResults()
  {
    String result = "";
    this.reactionsTimes.forEach((elapse){
      result+=elapse.status + ": " + (elapse.reactionTime.inMilliseconds/1000).toString()+"\n";
    });
    return result;
  }

}
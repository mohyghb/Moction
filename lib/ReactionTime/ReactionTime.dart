import 'package:moction/ReactionTime/Content.dart';
import 'package:moction/ReactionTime/NumberOfObjects.dart';
import 'package:moction/ReactionTime/Timer.dart';
import 'package:moction/ReactionTime/TypeTest.dart';

import 'package:moction/Test/Data.dart';

class ReactionTime{


  Timer timer;
  NumberOfObjects numberOfObjects;
  Content content;
  TypeTest type;

  String data;

  ReactionTime(String data)
  {
    init(data);
  }

  void init(String data){
    this.timer = new Timer(Timer.DEFAULT);
    this.numberOfObjects = new NumberOfObjects(NumberOfObjects.DEFAULT);
    this.content = new Content(Content.DEFAULT);
    this.type = new TypeTest(TypeTest.DEFAULT);
    this.data = data;

    parseData(data);
  }

  void parseData(String data)
  {
    List<String> splitData = data.split("\n");
    for(int i = 0;i<splitData.length;i++){
      String dataFromList = splitData[i];
      if(dataFromList.isNotEmpty){
        parseDataFromList(dataFromList);
      }
    }

    ///parsing data is done
    ///so that the type knows what kind of choices it can provide
  //  this.type.parseType(this.content.typeOfContent);

    this.type.content = this.content;
    this.content.type = this.type;


    this.type.init();


  }

  void parseDataFromList(String data)
  {
    List<String> line = data.split(":");
    String type = line[0];
    String dataFromLine = line[1];

    switch(type)
    {
      case DataConstants.NUMBER_OF_OBJECTS:
        this.numberOfObjects = new NumberOfObjects(dataFromLine);
        break;
      case DataConstants.CONTENT:
        this.content = new Content(dataFromLine);
        break;
      case DataConstants.TIMER:
        this.timer = new Timer(dataFromLine);
        break;
      case DataConstants.TYPE:
        this.type = new TypeTest(dataFromLine);
        break;
    }
  }


  bool isDone()
  {
    return this.numberOfObjects.isZero();
  }



  void restart()
  {
    init(this.data);
  }



}
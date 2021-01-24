import 'package:moction/Test/Data.dart';
import 'package:moction/MoWidgets/MoRandom.dart';

class Timer{

  static const DEFAULT = "7";

  final int maxTime = 5;
  final int minTime = 4;

  double time;
  String data;

  Timer(String data){
    this.data = data.trim();
    parseData(this.data);
  }

  void parseData(String data)
  {
    try{
      this.time = double.parse(data);
    }catch(error){
      this.time = (minTime+MoRandom.random.nextInt(maxTime)).toDouble();
    }
  }


  updateTime(){
    if(this.data == DataConstants.RANDOM_CHANGER){
      this.time = (minTime+MoRandom.random.nextInt(maxTime)).toDouble();
    }
  }

  Duration getDuration()
  {
    return Duration(seconds: this.time.toInt());
  }

}
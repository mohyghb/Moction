import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoStopWatch/FormatTime.dart';
import 'package:moction/MoWidgets/MoPadding.dart';

class Elapsed{

  static const String CORRECT = "CORRECT";
  static const String WRONG = "WRONG";
  static const String MISSED_ONE = "MISSED_ONE";
  static const String TAPPED_MORE_THAN_ONCE = "TAPPED_MORE_THAN_ONCE";

  static const String STATUS = "STATUS";
  static const String TIME = "TIME";

  Duration _reactionTime;
  String _status;

  Elapsed(this._reactionTime, this._status);


  Duration get reactionTime => _reactionTime;

  set reactionTime(Duration value) {
    _reactionTime = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  Widget toWidget(BuildContext context)
  {
    return MoCard(
      mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        cardRadius: MoCard.ROUND_REC_RADIUS,
        backgroundColor: Theme.of(context).primaryColor,
        childPadding: MoPadding(
          paddingAll: 16.0
        ),
        childRow: <Widget>[
          Expanded(child: new Text(FormatTime.readableForm(this.reactionTime.inMilliseconds.toString()), textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)),
          Expanded(child: new Text("Status: " + this.status, textAlign: TextAlign.center,style: TextStyle(color: Colors.white))),
        ],
    );
  }


  toJson(){
    return {
      TIME : this.reactionTime.toString(),
      STATUS : this.status
    };
  }

  toClass(dynamic data)
  {
    this.status = data[STATUS];

    String time  = data[TIME];
    List<String> splitTime = time.split(":");

    List<String> secmilli = splitTime[2].split(".");
    this.reactionTime = new Duration(
        hours: int.parse(splitTime[0]),
        minutes: int.parse(splitTime[1]),
      seconds: int.parse(secmilli[0]),
      milliseconds: (int.parse(secmilli[1])/1000).floor()
    );


  }



}


class ElapsedFunctions
{

  /// retruns a list with
  /// [0] = sum of all of the reaction elapses reaction time
  /// [1] = average of all the reaction elapses
  static List<double> getAverageMilliSeconds(List<Elapsed> list)
  {
    List<double> sumAve = new List();
    double sum = 0;
    int size = 0;
    for(Elapsed e in list){
      if(e.status == Elapsed.CORRECT){
        size++;
        sum += e._reactionTime.inMilliseconds;
      }
    }
    sumAve.add(sum);
    if(size>0){
      sumAve.add(sum/size);
    }else{
      sumAve.add(0);
    }
    return sumAve;
  }
}


import 'package:moction/Test/Test.dart';

/// a moCode is a string starting
/// with a *
/// and following it there is a code
/// e.g
/// *14223425
/// *1
/// *123
/// each code performs a special function to get either the scores or times of
/// a test
///
/// all the numbers starting with a :
/// 1 show that we want to get the score
/// 2 shows that we want to get the times

class MoCode
{

  static const String SCORE = "1";
  static const String TIME = "2";
  static const String LENGTH = "3";

  /// the list has a length of 2
  /// list[0] is the number of the items in it (COUNT)
  /// list[1] is the total value (TOTAL)
  ///
  static List<double> getTotalAndCount(String code,Test test)
  {
    switch(code.trim())
    {
      case OMS:
        return ontarioModifiedStratify(test);
        break;
      default:
        return [0,0];
        break;
    }
  }


  static const String OMS = "100";
  static List<double> ontarioModifiedStratify(Test test)
  {
    double count = 0;
    double sum = 0;

    int length = test.subs.length;

    int oneBeforeLast = length-2;

    for(int i = 0;i<length;i++){
      double countSub = test.subs[i].countScore;
      double sumSub = test.subs[i].totalScore;
      if(i==length-1){
        break;
      }
      if(i==oneBeforeLast){
        double totalScore = sumSub+test.subs[i+1].totalScore;
        if(totalScore>=3&&totalScore<=6) {
          sum+=7;
          count+=countSub+test.subs[i+1].countScore;
        }
      }else{
        sum+=sumSub;
        count+=countSub;
      }
    }
    return [count,sum];
  }



}
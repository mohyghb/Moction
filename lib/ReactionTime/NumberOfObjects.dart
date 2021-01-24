import 'package:moction/Test/Data.dart';
import 'package:moction/MoWidgets/MoRandom.dart';
class NumberOfObjects{

  static const DEFAULT = "7";

  final int maxNumberAdd = 6;
  final int leastNumber = 4;

  int number;
  int ogNumber;
  String data;

  NumberOfObjects(String data){
    this.data = data;
    parseNumber(data);
  }

  parseNumber(String data)
  {
    switch(data)
    {
      case DataConstants.RANDOM:
        this.number = MoRandom.random.nextInt(leastNumber + maxNumberAdd);
        break;
      default:
        this.number = int.parse(data);
        break;
    }

    this.ogNumber = this.number;

  }


  sub1(){
    this.number-=1;
  }

  bool isZero()
  {
    return this.number==0;
  }


  bool isFirstContent()
  {
    return this.ogNumber == this.number;
  }


}
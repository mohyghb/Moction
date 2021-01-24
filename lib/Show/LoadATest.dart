import 'package:moction/Test/Test.dart';




class LoadATest{


  Test test;

  LoadATest(this.test);

  Future<bool> startLoading() async
  {
    await this.test.getSubsOfTest().then((bool b){
      if(b){
        return true;
      }
      return false;
    });
    return false;
  }


}
class MoString{


  /// takes a list of string and converts it into a single string by doing:
  /// list[0]+"\n"+list[1]+"\n"+........
  static String convertList(List<String> list){
    String converted = "";
    for(int i = 0;i<list.length;i++){
      if(i==list.length-1){
        converted+=list[i];
      }else{
        converted+=list[i]+"\n";
      }
    }
    return converted;
  }



}




class MoData{


  /// takes a string and splits it based on the List<String> rules
  /// that they give us:
  /// e.g
  /// String str = "{hello}{why}{this}"
  /// we want [hello,why,this]
  /// so we have to call split(str, ["{","}"]),
  /// this means that until you have not seen all the components do not
  /// split it (rules must be in order that they want)
  /// rules must be larger than or equal to 2
  static List<String> split(String str, List<String> rules)
  {
    List<String> splitList = new List();

    int rulesLength = rules.length;
    int indexRules = 0;
    String currentRule = rules[indexRules];
    int savedIndexString = 0;
    for(int i = 0;i<str.length;i++){
      if(i+currentRule.length > str.length){
        break;
      }

      bool match = str.substring(i,i+currentRule.length) == currentRule;
      if(match && indexRules == 0){
        savedIndexString = i;
        indexRules++;
        currentRule = rules[indexRules];
      }
      else if(match)
      {
        /// if the index rules == the rules length
        /// that means we have found an element that they want
        /// else
        if(rulesLength == indexRules+1){
          /// split what ever was before it
          /// but not all the things before it
          splitList.add(str.substring(savedIndexString+1,i));
          /// reset index rules
          indexRules = 0;
          currentRule = rules[indexRules];
        }else{

          //increase the index rules by one
          indexRules++;
          currentRule = rules[indexRules];

        }
      }
    }

    return splitList;
  }


}
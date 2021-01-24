import 'package:moction/Test/Test.dart';

/// takes a string of logic codes and operates on them

class MoLogic{

  static const String NO_RESULT_FOUND = "NO_RESULT_FOUND";
  static const String CONDITION_NOT_MATCHED = "CONDITION_NOT_MATCHED";

  static const String AND = "and";
  static const String OR = "or";

  static const String GREATER = ">";
  static const String SMALLER = "<";
  static const String GREATER_EQUAL = ">=";
  static const String SMALLER_EQUAL = "<=";
  static const String EQUAL = "=";
  static const String RANGE = "@";
  static const String RANGE_SEP = "-";

  static const String BREAK = "break;";
  static const String CASE = ":";
  static const String OPEN_BRACKET = "(";
  static const String CLOSED_BRACKET = ")";


  static const String RETURN_LOGIC = "*";

  /// logics are in a form of:
  /// case(g=1anda=23):
  ///  .... some code to run
  ///  break;
  ///
  ///

  static List<String> performLogic(Map<String,double> values,String logic)
  {
    List<String> results = new List();

    List<String> cases = logic.split(BREAK);

    for(String logicCase in cases){
      if(logicCase.isNotEmpty){
        var result = logicForCase(values, logicCase);
        if(result!=null){
          results.addAll(result);
          return results;
        }
      }
    }

    return results;

  }


  static List<String> logicForCase(Map<String,double> values,String logicCase)
  {
    List<String> sep = logicCase.split(CASE);
    if(sep.length==2){
      String casePredicate = sep[0];
      String performLogic = sep[1];

      if(isTrue(values, parsePredicateCase(casePredicate))){
        return logicForEveryLine(values, performLogic);
      }
    }

    return null;
  }


  static String parsePredicateCase(String logicCase)
  {
    return logicCase.split(OPEN_BRACKET)[1].split(CLOSED_BRACKET)[0];
  }


  static bool isTrue(Map<String,double> values,String line)
  {
    return performConditionOr(values,removeSpaces(line));
  }














  static List<String> logicForEveryLine(Map<String,double> values,String logic)
  {

    //logic results
    List<String> results = new List();

    // separate each line of the logic
    List<String> lines = logic.split("\n");

    // go through each line and perform that logic for it
    for(int i = 0;i<lines.length;i++){
      String line = lines[i];

      // perform logic on one line
      // remove the spaces in that line
      String rfl = performLogicOnLine(values,line);
      if(rfl!=CONDITION_NOT_MATCHED&&rfl!=NO_RESULT_FOUND){
        results.add(rfl);
      }
    }

    return results;
  }


  static String performLogicOnLine(Map<String,double> values,String line)
  {
    List<String> statements = line.split("|");
    if(statements.length>=2){
      String condition = statements[0];
      String result = statements[1];

      if(performConditionOr(values,removeSpaces(condition))){
        return result;
      }else{
        return CONDITION_NOT_MATCHED;
      }

    }else{
      return NO_RESULT_FOUND;
    }
  }

  static bool performConditionOr(Map<String,double> values,String condition)
  {
    //if either one of these statements is true, performCondition returns true;
    List<String> orStatements = condition.split(OR);

    //add case for which the orStatements.length == 0 just call the performCondtionAnd and then
    // there is a case for which there is no or
    // and there is a case for which there is no and
    if(orStatements.length==1){
      return performConditionAnd(values,condition);
    }else{
      for(int i = 0;i<orStatements.length;i++){
        if(performConditionAnd(values,orStatements[i])){
          return true;
        }
      }
    }


    return false;
  }

  static bool performConditionAnd(Map<String,double> values,String condition)
  {
    List<String> andStatements = condition.split(AND);

    //add case for which the andStatements.length == 0
    // call the logic

    if(andStatements.length==1){
      return logic(values,condition);
    }else{
      for(int i =0;i<andStatements.length;i++){
        if(!logic(values,andStatements[i])){
          return false;
        }
      }
    }
    return true;
  }

  // takes an atomic level condition like 2>3 and returns the value
  static bool logic(Map<String,double> values,String condition)
  {
    List<String> atomicLevel = getAtomicLevel(condition);
    if(atomicLevel.length==3){
      String left = atomicLevel[0];
      String right = atomicLevel[1];
      String sign = atomicLevel[2];
      return logicSign(left, right, sign,values);
    }else{
      print("failed");
      return false;
    }
  }

  static List<String> getAtomicLevel(String condition)
  {
    List<String> atomicLevel = new List();
    String symbol = "";
    if(condition.contains(RANGE)){
      symbol = RANGE;
    }else if(condition.contains(GREATER_EQUAL)){
      symbol = GREATER_EQUAL;
    }else if(condition.contains(SMALLER_EQUAL)){
      symbol = SMALLER_EQUAL;
    }else if(condition.contains(SMALLER)){
      symbol = SMALLER;
    }else if(condition.contains(GREATER)){
      symbol = GREATER;
    }else if(condition.contains(EQUAL)) {
      symbol = EQUAL;
    }
    atomicLevel.addAll(condition.split(symbol));
    atomicLevel.add(symbol);
    return atomicLevel;
  }



  static bool logicSign(String left,String right,String sign,Map<String,double> values)
  {
    if(sign == RANGE){
      List<String> range = new List();
      if(left.contains(RANGE_SEP)){
        range.addAll(left.split(RANGE_SEP));
        String newLogic = "$right>=${range[0]}and$right<=${range[1]}";
        return performConditionAnd(values, newLogic);
      }else if(right.contains(RANGE_SEP)){
        range.addAll(right.split(RANGE_SEP));
        String newLogic = "$left>=${range[0]}and$left<=${range[1]}";
        return performConditionAnd(values, newLogic);
      }
    }

    try{
      double leftValue;
      double rightValue;

      //init leftValue
      try{
        leftValue = double.parse(left);
      }catch(e){
        leftValue = values[left];
      }

      //init rightValue
      try{
        rightValue = double.parse(right);
      }catch(e){
        rightValue = values[right];
      }

      switch(sign){
        case GREATER_EQUAL:
          return (leftValue>=rightValue);
        case SMALLER_EQUAL:
          return (leftValue<=rightValue);
        case SMALLER:
          return (leftValue<rightValue);
        case GREATER:
          return (leftValue>rightValue);
        case EQUAL:
          return (leftValue==rightValue);
      }
    }catch(e){
      return false;
    }


    return false;
  }


  // removes all the spaces of a string
  static String removeSpaces(String text)
  {
    return text.replaceAll(" ", "");
  }



  /// when there is String inside the los(List of string)
  static logicIsTrue(Map<String,double> values,String logic)
  {
    if(performLogic(values, logic).isNotEmpty){
      return true;
    }
    return false;
  }








}
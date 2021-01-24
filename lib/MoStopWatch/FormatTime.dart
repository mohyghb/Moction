

class FormatTime
{

  /// takes a time in milliseconds and converts it into a
  /// readable form for humans
  /// e.g 764 => 00:07:64
  static String readableForm(String time) {
    try {
      double milli = double.parse(time);

      double seconds = 0;
      double minutes = 0;
      double hour = 0;

      while (milli >= 1000) {
        seconds++;
        milli -= 1000;
      }
      while (seconds >= 60) {
        seconds -= 60;
        minutes++;
      }

      while(minutes>=60){
        minutes -= 60;
        hour++;
      }

      return putTogether(hour, minutes, seconds, milli);
    } catch (e) {
      return time;
    }
  }

  /// put together time in readable human form
  /// e.g 07:44:21 indicates 7 minutes, 44 seconds and 21 milli seconds
  static String putTogether(double ho,double min, double sec,double mil)
  {
    String hour = getTimeString(ho);
    String minute = getTimeString(min);
    String second = getTimeString(sec);
    String milli = getTimeString(mil);

    return hour + " : "+ minute + " : " + second + "." + milli;
  }


  /// gets a double
 ///  returns the double as string if not zero
///  returns 00 if zero
  static String getTimeString(double t)
  {
    if(t==0){
      return "00";
    }else if(t<10){
      return "0" + t.floor().toString();
    } else{
      return t.floor().toString();
    }
  }






}
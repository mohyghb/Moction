import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';


// ignore: must_be_immutable
class MoTextFormField extends StatelessWidget
{

  static const double FONT_SIZE = 16;
  static const double BORDER_RADIUS = 10.0;
  static const String PLEASE_ENTER_A = "Please Enter a ";

  String text;
  String hintText;
  String labelText;


  /// interactions
  ValueChanged<String> onValueChanged;
  TextEditingController controller;
  bool enabled;
  bool isPassword;
  TextInputType keyBoardType;

  ///customizations
  bool hasRoundBorders;
  bool hasNormalBorder;
  double borderRadius;
  double borderWidth;
  Color borderColor;
  Color cursorColor;
  IconData iconData;
  Icon icon;
  ThemeData themeData;

  double fontSize;
  int maxLines;
  int maxLength;


  ///padding
  double paddingAll;
  double paddingLeft;
  double paddingRight;
  double paddingTop;
  double paddingBottom;

  double paddingWidths;
  double paddingHeights;

  double totalRightPadding;
  double totalLeftPadding;
  double totalTopPadding;
  double totalBottomPadding;


  Widget suffix;
  Widget suffixIcon;


  ///focus nodes
  FocusNode focusNode;
  FocusNode nextFocus;
  VoidCallback onDone;
  bool noValidationRequired;







  MoTextFormField({
    this.text,
    this.iconData,
    this.enabled,
    this.isPassword,
    this.fontSize,
    this.cursorColor,
    this.onValueChanged,
    this.maxLines,
    this.maxLength,
    this.icon,
    this.labelText,
    this.hintText,
    this.paddingAll,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.paddingTop,
    this.hasRoundBorders,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.hasNormalBorder,
    this.nextFocus,
    this.keyBoardType,
    this.paddingHeights,
    this.paddingWidths,
    this.themeData,
    this.onDone,
    this.suffix,
    this.suffixIcon,
    this.noValidationRequired
  }){
    this.controller = new TextEditingController();
    this.focusNode = new FocusNode();

    double totalPadding = MoNotNull.Double(this.paddingAll);



    totalRightPadding = MoNotNull.Double(this.paddingRight) + totalPadding + MoNotNull.Double(this.paddingWidths);
    totalLeftPadding = MoNotNull.Double(this.paddingLeft) + totalPadding + MoNotNull.Double(this.paddingWidths);
    totalTopPadding = MoNotNull.Double(this.paddingTop) + totalPadding + MoNotNull.Double(this.paddingHeights);
    totalBottomPadding = MoNotNull.Double(this.paddingBottom) + totalPadding + MoNotNull.Double(this.paddingHeights);


    /// setting the text if it's not null
    this.controller.text = MoNotNull.string(this.text);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build




    return Theme(
      data: MoNotNull.theme(this.themeData, context),
      child: Padding(
        padding: EdgeInsets.only(left: totalLeftPadding,right: totalRightPadding,top: totalTopPadding,bottom: totalBottomPadding),
        child: TextFormField(

          //check and see it would work without a text editing controller
          controller: this.controller,


          keyboardType: MoNotNull.Dynamic(this.keyBoardType),
          maxLines: MoNotNull.integer(maxLines,returnThis: 1),
          enabled: MoNotNull.boolean(this.enabled,returnThis: true),
          obscureText: MoNotNull.boolean(this.isPassword),
          cursorColor: MoNotNull.color(this.cursorColor,returnThis:Theme.of(context).cursorColor ),
          focusNode: this.focusNode,
          maxLength: this.maxLength,
          validator: (String value){

            /// based on their label text we can:
            /// case for email
            /// password
            /// phonenumber
            /// name
            /// empty cases
            /// etc.
            ///

            dynamic validate = MoTextFormFields.validate(value,
                mode: this.labelText,
                noValidationRequired: this.noValidationRequired);

            if(validate!=true){
              return validate;
            }

          },

          onFieldSubmitted: (String s){
            /// add rules so that they can not leave them empty if it is necessary field

            if(this.nextFocus!=null){
              FocusScope.of(context).requestFocus(nextFocus);
            }else if(this.onDone!=null){
              this.onDone();
            }
          },
          cursorWidth: 2,
          textInputAction: this.nextFocus==null?(this.onDone==null)?TextInputAction.newline:TextInputAction.done:TextInputAction.next,
          decoration: new InputDecoration(
            /// test enabled border and disabled border to see if it has the width that we are asking it to have
            enabledBorder: getBorder(Colors.black),
            disabledBorder: getBorder(Colors.black),
            focusedBorder: getBorder(MoNotNull.theme(this.themeData, context).primaryColor),
            suffix: this.suffix,
            suffixIcon: this.suffixIcon,
            border: getBorder(Colors.black),
              hasFloatingPlaceholder: true,
              icon: getIcon(),
              hintText: MoNotNull.string(this.hintText),
              labelText: MoNotNull.string(this.labelText),
          ),
        ),
      ),
    );
  }


  /// make the width dynamic
  InputBorder getBorder(Color borderColor)
  {
    if(MoNotNull.boolean(this.hasRoundBorders)){
      return new OutlineInputBorder(
        borderSide: BorderSide(
          color: MoNotNull.color(borderColor,returnThis: Colors.black),
          width: MoNotNull.Double(this.borderWidth),
        ),

        borderRadius: BorderRadius.all(
          Radius.circular(MoNotNull.Double(this.borderRadius,returnThis: BORDER_RADIUS)),
        ),
      );
    }
    else if(MoNotNull.boolean(this.hasNormalBorder)){
      return new UnderlineInputBorder(
        borderSide: BorderSide(
            color: MoNotNull.color(borderColor,returnThis: Colors.black),
            width: MoNotNull.Double(this.borderWidth),
        ),
        borderRadius: BorderRadius.only(topLeft:Radius.circular(MoNotNull.Double(this.borderRadius,returnThis: BORDER_RADIUS)),
        ),
      );
    }
    return InputBorder.none;
  }


  Widget getIcon()
  {
    if(this.icon!=null){
      return this.icon;
    }
    if(this.iconData!=null){
      return Icon(this.iconData);
    }
    return null;
  }


  String getText()
  {
    return this.controller.text;
  }

  void setText(String text)
  {
    this.controller.text = text;
  }


  void dispose()
  {
    this.controller.dispose();
    if(this.focusNode!=null){
      this.focusNode.dispose();
    }
    if(this.nextFocus!=null){
      this.nextFocus.dispose();
    }
  }

}


class MoTextFormFields
{
  //different versions of moText
  static const String ENTER_A = "Enter a ";
  static const String ENTER_YOUR = "Enter your ";
  static const String NAME = "Name";
  static const String LAST_NAME = "Last Name";
  static const String FULL_NAME = "Full Name";
  static const String USERNAME = "Username";
  static const String PASSWORD = "Password";
  static const String PHONE_NUMBER = "Phone number";
  static const String EMAIL = "Email";
  static const String AGE = "Age";
  static const String ADDRESS = "Address";
  static const String NOT_REQUIRED = "NOT_REQUIRED";

  static const double NORMAL_PADDING = 8.0;
  static const double LARGE_PADDING = 16.0;

  static const double FANCY_BORDER_RADIUS = 20.0;
  static const double CIRCLE_BORDER_RADIUS = 30.0;



  /// init a MoText only if the bool b is true
  /// set the value of thisMoText to textField
  static void initIfTrue(MoTextFormField thisMoText,MoTextFormField textField,bool b,List<Widget> widgets,{ThemeData themeData})
  {
    if(MoNotNull.boolean(b)){
      thisMoText = textField;
      thisMoText.themeData = themeData;
      widgets.add(thisMoText);
    }
  }






  // ignore: non_constant_identifier_names
  static MoTextFormField NAME_TEXT_FIELD(){
    return new MoTextFormField(
      hintText: ENTER_A + NAME,
      labelText: NAME,
      hasNormalBorder: true,
      iconData: Icons.person,

      paddingAll: NORMAL_PADDING,
      paddingWidths: LARGE_PADDING,
      paddingTop: NORMAL_PADDING,

    );
  }

  static MoTextFormField LAST_NAME_TEXT_FIELD (){
    return new MoTextFormField(
      hintText: ENTER_A + LAST_NAME,
      labelText: LAST_NAME,
      iconData: Icons.person_outline,
      hasNormalBorder: true,
      paddingAll: NORMAL_PADDING,
      paddingWidths: LARGE_PADDING,
    );
  }


  static MoTextFormField USERNAME_TEXT_FIELD(){
    return new MoTextFormField(
      hintText: ENTER_A + USERNAME,
      labelText: USERNAME,
      hasRoundBorders: true,
      maxLength: 20,
     // borderRadius: CIRCLE_BORDER_RADIUS,
      iconData: Icons.supervised_user_circle,
      paddingAll: NORMAL_PADDING,
    );
  }


  static MoTextFormField PASSWORD_TEXT_FIELD (){
    return new MoTextFormField(
      hintText: ENTER_A + PASSWORD,
      labelText: PASSWORD,
      hasRoundBorders: true,
      isPassword: true,
      iconData: Icons.vpn_key,
    //  borderRadius: CIRCLE_BORDER_RADIUS,
      paddingAll: NORMAL_PADDING,
    );
  }

  static MoTextFormField PHONE_NUMBER_TEXT_FIELD({
    bool round,
    bool normal,
    double borderRadius,
    double paddingAll,
    double paddingWidth,
    IconData icon
  }){
    return new MoTextFormField(
      hintText: ENTER_YOUR + PHONE_NUMBER,
      labelText: PHONE_NUMBER,
      hasNormalBorder: normal,
      hasRoundBorders: round,
     // borderRadius: borderRadius,
      iconData: MoNotNull.Dynamic(icon,returnThis:Icons.phone),
      keyBoardType: TextInputType.numberWithOptions(signed: false,decimal: false),
      paddingAll: MoNotNull.Double(paddingAll,returnThis: NORMAL_PADDING),
     // paddingWidths: MoNotNull.Double(paddingWidth,returnThis: LARGE_PADDING),
    );
  }

  static MoTextFormField EMAIL_TEXT_FIELD (){
    return new MoTextFormField(
      hintText: ENTER_YOUR + EMAIL,
      labelText: EMAIL,
      hasRoundBorders: true,
     // borderRadius: CIRCLE_BORDER_RADIUS,
      iconData: Icons.email,
      paddingAll: NORMAL_PADDING,
    );
  }

  static MoTextFormField AGE_TEXT_FIELD (){
    return new MoTextFormField(
      hintText: ENTER_YOUR + AGE,
      labelText: AGE,
      hasRoundBorders: true,
      keyBoardType: TextInputType.numberWithOptions(signed: false,decimal: false),
      //borderRadius: CIRCLE_BORDER_RADIUS,
      iconData: Icons.date_range,
      paddingAll: NORMAL_PADDING,
    );
  }

  static MoTextFormField FULL_NAME_TEXT_FIELD(){
    return new MoTextFormField(
      hintText: ENTER_YOUR + FULL_NAME,
      labelText: FULL_NAME,

      hasRoundBorders: true,
      //borderRadius: CIRCLE_BORDER_RADIUS,
      iconData: Icons.person,
      paddingAll: NORMAL_PADDING,
    );
  }

  static MoTextFormField ADDRESS_TEXT_FIELD(){
    return new MoTextFormField(
      hintText: ENTER_YOUR + ADDRESS,
      labelText: ADDRESS,
      hasRoundBorders: true,
      //borderRadius: CIRCLE_BORDER_RADIUS,
      iconData: Icons.location_city,
      paddingAll: NORMAL_PADDING,
    );
  }

  static MoTextFormField makeDynamicField_RecRound({String hint,String label, IconData icon,int maxLines})
  {
    return MoTextFormField(
      hintText: hint,
      labelText: label,
      hasRoundBorders: true,
      iconData: icon,
      maxLines: maxLines,

      paddingAll: MoTextFormFields.NORMAL_PADDING,

    );
  }



    static void syncFocusNodes(List<MoTextFormField> widgets, VoidCallback voidCallBack)
    {
      int len = widgets.length;
      for(int i = 0;i<len;i++){
        if(i!=len-1){
          widgets[i].nextFocus = widgets[i+1].focusNode;
        }else{
          widgets[i].onDone = voidCallBack;
        }
      }
    }

    static Form getForm(GlobalKey<FormState> key, List<Widget> widgets)
    {
      return new Form(
        key: key,
        child: new Column(
          children: widgets,
        ),
      );
    }


    static dynamic validate(String text, {String mode, bool noValidationRequired})
    {
      if(MoNotNull.boolean(noValidationRequired)){
        return true;
      }
      else if(mode == null){
        return validateNotEmpty(text,mode: mode);
      }
      else if(mode.startsWith(PASSWORD)){
        return validatePassword(text, mode: mode);
      }
      else if(mode.startsWith(EMAIL)){
        return validateEmail(text, mode: mode);
      }
      else if(mode.startsWith(PHONE_NUMBER)){
        return validatePhoneNumber(text,mode: mode);
      }
      else if(mode.startsWith(AGE)){
        return validateAge(text,mode:mode);
      }
      else{
        return validateNotEmpty(text,mode: mode);
      }
    }

    static const PLZ_ENTER_A  = "Please Enter A Valid ";


    static dynamic validateNotEmpty(String text, {String mode})
    {
      if(MoNotNull.string(text).isEmpty || hasWeirdChar(text)){
        return PLZ_ENTER_A + MoNotNull.string(mode);
      }else if(MoNotNull.string(text).contains(new RegExp(r"\w"))){
        return true;
      }
      else{
        return PLZ_ENTER_A + MoNotNull.string(mode) + "(In English Please)";
      }
    }


    static const MIN_PASSWORD_LENGTH = 8;

    static dynamic validatePassword(String password, {String mode})
    {
      if(MoNotNull.string(password).length >= MIN_PASSWORD_LENGTH){
        return true;
      }
      return PLZ_ENTER_A + MoNotNull.string(mode) + " with at least " + MIN_PASSWORD_LENGTH.toString() + " characters";
    }


    static dynamic validateEmail(String email, {String mode})
    {
      if(!MoNotNull.string(email).contains("@")){
        return PLZ_ENTER_A + "valid " + MoNotNull.string(mode) + "\n" + "A valid email contains @";
      }
      else if(!MoNotNull.string(email).contains(".")){
        return PLZ_ENTER_A + "valid " + MoNotNull.string(mode) + "\n" + "A valid email contains .com or .net or .etc.";
      }
      return true;
    }


    static const int EXACT_DIGITS_PHONE_NUMBER = 10;
    static const String PHONE_NUMBER_ERROR_EXACT_DIGITS = "A phone number must have 10 digits";
    /// phone number also can not be negative or have '.'
  static dynamic validatePhoneNumber(String phoneNumber, {String mode})
  {
    if(MoNotNull.string(phoneNumber).length!=EXACT_DIGITS_PHONE_NUMBER){
      return PHONE_NUMBER_ERROR_EXACT_DIGITS;
    }
    return true;
  }

  static const String AGE_ERROR_OUT_OF_BOUND = "The age must be higher than 0.";
  static const String AGE_EMPTY_ERROR = "Please enter your age";
  static dynamic validateAge(String age, {String mode})
  {
    double ageDouble;
    try{
      ageDouble = double.parse(MoNotNull.string(age));
    }catch(e){
      return AGE_EMPTY_ERROR;
    }
    if(MoNotNull.Double(ageDouble)>0){
      return true;
    }
    return AGE_ERROR_OUT_OF_BOUND;
  }



  static bool hasWeirdChar(String text)
  {
    if(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(text)){
      return true;
    }else{
      return false;
    }
  }




}

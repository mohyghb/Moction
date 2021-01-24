import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';


// ignore: must_be_immutable
class MoTextField extends StatelessWidget
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









  MoTextField({
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
        child: TextField(

          //check and see it would work without a text editing controller
          controller: this.controller,

          keyboardType: MoNotNull.Dynamic(this.keyBoardType),
          maxLines: MoNotNull.integer(maxLines,returnThis: 1),
          enabled: MoNotNull.boolean(this.enabled,returnThis: true),
          obscureText: MoNotNull.boolean(this.isPassword),
          cursorColor: MoNotNull.color(this.cursorColor,returnThis: Theme.of(context).cursorColor),
          focusNode: this.focusNode,
          maxLength: this.maxLength,
          onChanged: this.onValueChanged,
          cursorWidth: 2,
          textInputAction: this.nextFocus==null?TextInputAction.done:TextInputAction.next,
          decoration: new InputDecoration(
            /// test enabled border and disabled border to see if it has the width that we are asking it to have
            enabledBorder: getBorder(Colors.black),
            disabledBorder: getBorder(Colors.black),
            focusedBorder: getBorder(MoNotNull.theme(this.themeData, context).primaryColor),
            suffix: MoNotNull.widget(this.suffix),
            suffixIcon: MoNotNull.widget(this.suffixIcon),
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
    return SizedBox();
  }


  String getText()
  {
    return this.controller.text;
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






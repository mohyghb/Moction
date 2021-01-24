
import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class MoChecker extends StatefulWidget{

  bool value;
  ValueChanged<bool> onValueChanged;

  MoPadding padding;
  MoPadding childPadding;


  Widget whenFalseBody;
  Widget whenTrueBody;

  Color whenTrueColor;
  Color whenFalseColor;

  double width;
  double radius;


  bool disabled;

  MoChecker({
    this.value,
    this.onValueChanged,
    this.padding,
    this.whenTrueColor,
    this.whenFalseColor,
    this.whenFalseBody,
    this.whenTrueBody,
    this.width,
    this.childPadding,
    this.radius,
    this.disabled
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MoCheckerState();
  }



}

class MoCheckerState extends State<MoChecker>{


  bool value;
 // ValueChanged<bool> onValueChanged;

  Color whenTrueColor;
  Color whenFalseColor;

  Widget whenFalseBody;
  Widget whenTrueBody;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.value = MoNotNull.boolean(widget.value);
  //  this.onValueChanged = MoNotNull.Dynamic(widget.onValueChanged,returnThis: (){});

    this.whenFalseColor = MoNotNull.color(widget.whenFalseColor,returnThis: Colors.red);
    this.whenTrueColor = MoNotNull.color(widget.whenTrueColor,returnThis: Colors.green);

    this.whenFalseBody = MoNotNull.widget(widget.whenFalseBody,returnThis: Icon(Icons.close,color: this.whenTrueColor,));
    this.whenTrueBody = MoNotNull.widget(widget.whenTrueBody,returnThis: Icon(Icons.check,color: this.whenFalseColor,));


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getBody();
  }


  Widget getBody()
  {
    return Padding(
      padding: MoPaddingVersions.getNotNullPadding(widget.padding),
      child: GestureDetector(
        onTap: (){
          //print("works1");
          if(!MoNotNull.boolean(widget.disabled)){
            this.value = !this.value;
            widget.onValueChanged(this.value);
          }

        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(MoNotNull.Double(widget.radius,returnThis: 15)),
          child: AnimatedContainer(

            width: MoNotNull.Double(widget.width, returnThis: 100.0),
            color: this.value?this.whenTrueColor:this.whenFalseColor,
            duration: Duration(milliseconds: 300),
            child: Padding(
              padding: MoPaddingVersions.getNotNullPadding(widget.childPadding),
              child: Center(child: this.value?this.whenTrueBody:this.whenFalseBody),
            ),
          ),
        ),
      ),
    );
  }


}
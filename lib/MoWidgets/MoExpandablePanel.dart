
import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoCard.dart';
import 'package:moction/MoWidgets/MoPadding.dart';


class MoExpandablePanel extends StatefulWidget{

  Widget header;
  Widget body;
  bool isExpanded;
  Duration duration;
  ThemeData themeData;

  MoPadding padding;

  double elevation;


  MoExpandablePanel(this.header,this.body,
      {
        this.themeData,
        this.duration,
        this.isExpanded,
        this.padding,
        this.elevation
      });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MoExpandablePanelState();
  }


}



class _MoExpandablePanelState extends State<MoExpandablePanel>  with SingleTickerProviderStateMixin{

  bool isExpanded;

  AnimationController expandController;
  Animation<double> animation;

  static const int NORMAL_ANIMATION_DURATION = 300;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isExpanded = MoNotNull.boolean(widget.isExpanded);
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration: MoNotNull.Dynamic(widget.duration,returnThis: Duration(milliseconds: NORMAL_ANIMATION_DURATION))
    );
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    if(this.isExpanded){
      expandController.forward();
    }
  }






  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getBody();
  }

  Widget animatedBody()
  {
    return SizeTransition(
      axisAlignment: 1.0,
        sizeFactor: this.animation,
      child: widget.body,
    );
  }


  Widget getBody()
  {
      return Theme(
        data: MoNotNull.theme(widget.themeData, context,returnThis: Theme.of(context)),
        child: GestureDetector(
          onTap: expand,
          child: MoCard(
            elevation: widget.elevation,
            childPadding: MoPadding(
              paddingAll: 20.0
            ),
            padding: widget.padding,
            cardRadius: MoCard.ROUND_REC_RADIUS,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            childColumn: <Widget>[
              getHeader(),
              animatedBody()
            ],
          ),
        ),
      );
  }


  Widget getHeader()
  {
    return widget.header;
  }


  expand()
  {
    setState(() {
      this.isExpanded = !this.isExpanded;
      if(this.isExpanded){
        this.expandController.forward();
      }else{
        this.expandController.reverse();
      }
    });
  }



  @override
  void dispose() {
    expandController.dispose();

    super.dispose();
  }



}
import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/MoWidgets/MoColor.dart';

class MoSliverAppBar extends StatefulWidget {

  static const double MO_BAR_HEIGHT = 300.0;
  static const TextStyle WHITE_TEXT_STYLE = TextStyle(color: Colors.white);
  static const double BACKGROUND_OPACITY = 0.9;

  String titleText;
  Widget title;

  List<Widget> actions;


  //customization
  double height;
  Color backgroundColor;
  Widget flexibleSpace;
  ImageProvider backGroundImage;

  String flexTitle;


  double elevation;

  Widget leading;


  bool centerTitle;
  bool pinned;
  bool floating;
  bool snap;
  bool backgroundHasOpacity;


  bool noLeading;



  MoSliverAppBar({
    this.title,
    this.titleText,
    this.actions,
    this.height,
    this.backgroundColor,
    this.flexibleSpace,
    this.flexTitle,
    this.backGroundImage,
    this.elevation,
    this.centerTitle,
    this.pinned,
    this.leading,
    this.floating,
    this.snap,
    this.backgroundHasOpacity,
    this.noLeading,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MoSliverAppBarState();
  }


}

class MoSliverAppBarState extends State<MoSliverAppBar>{


  Color backgroundColor;
  Color color;
  Brightness brightness;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    backgroundColor = MoNotNull.color(widget.backgroundColor,returnThis: MoColor.canvasColor);
    dynamic attrib = MoColor.getAppropriateDesign(this.backgroundColor, MoColor.TEXT_COLOR_AND_BRIGHTNESS);
    color = attrib[0];
    brightness = attrib[1];

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

      return new SliverAppBar(
            leading: MoNotNull.widget(widget.leading,returnThis: (MoNotNull.boolean(widget.noLeading))?new SizedBox():new IconButton(icon: Icon(Icons.arrow_back,color: color,), onPressed: (){
              Navigator.pop(context);
            })),
            forceElevated: true,
            brightness: this.brightness,
            elevation: MoNotNull.Double(widget.elevation),
            pinned: MoNotNull.boolean(widget.pinned),
            snap: MoNotNull.boolean(widget.snap),
            floating: MoNotNull.boolean(widget.floating),
            title: MoNotNull.Dynamic(widget.title,returnThis: new Text(MoNotNull.string(widget.titleText),style: TextStyle(color: color),)),
            actions: widget.actions,
            centerTitle: MoNotNull.boolean(widget.centerTitle),
            expandedHeight: MoNotNull.Double(widget.height,returnThis:  MoSliverAppBar.MO_BAR_HEIGHT),
            backgroundColor: MoNotNull.boolean(widget.backgroundHasOpacity)?this.backgroundColor.withOpacity(MoSliverAppBar.BACKGROUND_OPACITY):this.backgroundColor,
            flexibleSpace: getFlexibleSpace(),
      );
  //  }

  }




  getFlexibleSpace()
  {
    return MoNotNull.widget(widget.flexibleSpace,returnThis:
    MoSliverAppBars.centeredFlexSpace(MoTexts.titleText(context, MoNotNull.string(widget.flexTitle), this.backgroundColor,fontSize: 40)),);
  }




}

class MoSliverAppBars
{

  static double paddingDescription = 40;

  static MoSliverAppBar getMoSliverAppBar(BuildContext context,String flexTitle,{String title,
    Color color,
    double elevation,
    bool noLeading
  })
  {
    return new MoSliverAppBar(
      flexTitle: flexTitle,
      backgroundColor: color,
      titleText: title,
      elevation: elevation,
      noLeading: noLeading,
    );
  }



  static Widget centeredFlexSpace(Widget widget)
  {
    return new SafeArea(
        child: new Center(
          child: widget,
        )
    );
  }




  static Widget containerAppBar(String text)
  {
    return new Container(
      height: MoSliverAppBar.MO_BAR_HEIGHT,
      width: double.infinity,
      child: new Center(
        child: new Text(text,style: new TextStyle(fontFamily: 'QuickSandLight'),),
      ),
    );
  }




  static Widget getFlexibleSpace(BuildContext context, String title,String description,Color backgroundColor)
  {
    return FlexibleSpaceBar(
      // title: new Text(Helpers.cut10(widget.title),),
        background: SafeArea(

//                  child: Center(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    MoTexts.titleText(context, title, backgroundColor,fontSize: 40.0),
                    Padding(
                      padding: const EdgeInsets.only(left:16.0,right: 16,top: 8.0),
                      child: description==null?SizedBox(): new Text(description,
                        textAlign:TextAlign.center,style:
                        TextStyle(color:Colors.black54),),
                    ),

                  ],
                ),
            )));
  }



//  static Widget backButton(BuildContext context){
//    return IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
//      Navigator.of(context).pop();
//    });
//  }


}



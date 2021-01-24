
import 'package:flutter/material.dart';
import 'MoNotNull.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class MoPageView extends StatefulWidget{



  List<String> texts = ["1","2","3","4"];

  List<Widget> widgets;
  bool pageSnapping;

  bool pageIndicator;


  int currentPosition;
  int numberOfPages;


  MoPageView({this.widgets,this.pageIndicator,this.pageSnapping});



  List<Widget> getWidgets()
  {
    List<Widget> widgets = new List();
    for(int i = 0;i<texts.length;i++){
      widgets.add(new Text(texts[i],style: TextStyle(fontWeight: (this.currentPosition==i)?FontWeight.bold:FontWeight.normal),));
    }
    return widgets;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MoPageViewState();
  }



}


class MoPageViewState extends State<MoPageView>{

  PageController pageController;

  String currentPage;
  double currentPageTransition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    this.pageController = new PageController();
    currentPage = "1";
    this.currentPageTransition = 1;
    if(MoNotNull.boolean(widget.pageIndicator)){
      this.pageController.addListener((){
        setState(() {
          this.currentPageTransition = this.pageController.page + 1;
          this.currentPage = this.currentPageTransition.toInt().toStringAsFixed(0);
        });

      });
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        PageView(
          controller: this.pageController,
          pageSnapping: MoNotNull.boolean(widget.pageSnapping),
          children: MoNotNull.Dynamic(widget.widgets,returnThis:[]),
        ),
        SafeArea(
          child: getIndicatorWidget(),
        )
      ],
    );
  }

  Widget getIndicatorWidget()
  {
    return Padding(
      padding: const EdgeInsets.only(bottom:6.0),
      child: new PageIndicator(
        layout: PageIndicatorLayout.WARM,
        size: 10.0,
        controller: this.pageController,
        space: 5.0,
        activeColor: Colors.green,
        color: Colors.black54,
        count: widget.widgets.length,
      ),
    );
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

}
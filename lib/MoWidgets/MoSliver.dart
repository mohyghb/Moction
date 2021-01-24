import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:moction/MoWidgets/MoPadding.dart';

class MoSliver extends StatefulWidget{


  MoSliverAppBar appBar;


  List<Widget> widgets;
  List<Widget> widgets_2;

  List<Widget> adapterWidget;

  Widget child;


  bool bouncingScrollPhysics;
  MoPadding padding;

  String flexTitle;

  MoSliver({
    this.appBar,
    this.bouncingScrollPhysics,
    this.padding,
    this.widgets,
    this.flexTitle,
    this.widgets_2,
    this.adapterWidget,
    this.child
  });





  SliverPadding getAdapterWidget(List<Widget> widgets)
  {
    if(widgets!=null){
      return SliverPadding(
        padding: MoPaddingVersions.getNotNullPadding(this.padding),
        sliver: new SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: widgets,
          ),
        ),
      );
    }else{
      return SliverPadding(
        padding: EdgeInsets.all(0.0),
      );
    }
  }

  dynamic getSliverList(List<Widget> widgets)
  {
    if(widgets!=null){
      return SliverPadding(
        padding: MoPaddingVersions.getNotNullPadding(this.padding),
        sliver: new SliverList(delegate: SliverChildBuilderDelegate((context, index){
          if(index<widgets.length){
            return widgets[index];
          }
        })),
      );
    }
    return SliverToBoxAdapter(
      child: SizedBox(),
    );

  }

  ScrollPhysics getPhysics()
  {
    if(MoNotNull.boolean(this.bouncingScrollPhysics)){
      return BouncingScrollPhysics();
    }
    return FixedExtentScrollPhysics();
  }




  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MoSliverState();
  }


}
class MoSliverState extends State<MoSliver>{



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return CustomScrollView(

      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        MoNotNull.Dynamic(widget.appBar,returnThis: (widget.flexTitle==null)?SliverToBoxAdapter(child:SizedBox()):MoSliverAppBars.getMoSliverAppBar(context, widget.flexTitle)),
        SliverToBoxAdapter(
          child: MoNotNull.widget(widget.child),
        ),
        widget.getSliverList(widget.widgets),
        widget.getSliverList(widget.widgets_2),
        widget.getAdapterWidget(widget.adapterWidget)
      ],
    );
  }
}
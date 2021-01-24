import 'package:flutter/material.dart';

import 'package:moction/Firebase_Helpers/MoFirebase.dart';
import 'package:moction/Helpers.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/Loaded.dart';
import 'package:moction/MoWidgets/MoUseFullWidgets.dart';
import 'package:moction/Search/SearchAProgram.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/MoWidgets/MoPadding.dart';

import 'package:moction/Test/Program.dart';
import 'package:moction/MoWidgets/MoCard.dart';

class ShowPrograms extends StatefulWidget
{

  int mode;

  ShowPrograms(this.mode);



  @override
  _ShowProgramsState createState() => _ShowProgramsState();
}

class _ShowProgramsState extends State<ShowPrograms> {



  void initState()
  {
    super.initState();
    initClass();
  }

  void initClass() async
  {
    if(Loaded.programs==null){
      /// reload the tests only when
      /// the Loaded.tests are null
      /// or they pull down to refresh
      Loaded.programs = await MoFirebase.getPrograms(MoFirebase.getProgramBasicRef(),Program.PROGRAM_BASIC);
      print("loading programs");
    }

    if(mounted){
      setState(() {

      });
    }


  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: MoColor.canvasColor,
      resizeToAvoidBottomPadding: true,
      body: RefreshIndicator(
        onRefresh: refreshTests,
        child: MoSliver(
          padding: MoPadding(
            paddingAll: 2,
          ),

          appBar: MoSliverAppBar(
            backgroundHasOpacity: true,
            pinned: true,
            backgroundColor: MoColor.canvasColor,
            flexibleSpace: MoSliverAppBars.centeredFlexSpace(
                MoTexts.titleText(context, "Programs",MoColor.canvasColor,align: TextAlign.center)
            ),
            actions: <Widget>[
              new IconButton(icon: Icon(Icons.search,color: MoColor.objectsOnCanvas,), onPressed: ()=> this.search())
            ],
          ),
          widgets: this.getBody(context),
        ),
      ),
    );
  }



  Future refreshTests() async
  {
    Loaded.programs = await MoFirebase.getPrograms(MoFirebase.getProgramBasicRef(),Program.PROGRAM_BASIC);
    setState(() {
      print("refreshed");
    });
  }



  List<Widget> getBody(BuildContext context)
  {
    List<Widget> widgets = new List();

    if(Loaded.programs != null){
      if(Loaded.programs.length==0){
        widgets.add(MoUseFullWidgets.loading());
      }else{
        for(int i = 0;i<Loaded.programs.length;i++){
          widgets.add(Loaded.programs[i].getBasicWidget(context,widget.mode));
        }
      }
    }else{
      widgets.add(Helpers.loading());
    }
    return widgets;
  }



  search()
  {
    if(Loaded.programs != null){
      showSearch(context: context, delegate: SearchAProgram(Loaded.programs,widget.mode));
    }else{
      print("we can not until it is downloaded");
    }
  }






}

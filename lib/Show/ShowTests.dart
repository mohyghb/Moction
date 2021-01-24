import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoUseFullWidgets.dart';
import 'package:moction/Test/Test.dart';
import 'package:moction/Firebase_Helpers/MoFirebase.dart';
import 'package:moction/Helpers.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/Loaded.dart';
import 'package:moction/Search/SearchATest.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/MoWidgets/MoPadding.dart';

class ShowTests extends StatefulWidget
{

  String mode;
  String title;

  ShowTests(this.mode,{this.title});



  @override
  _ShowTestsState createState() => _ShowTestsState();
}

class _ShowTestsState extends State<ShowTests> {



  void initState()
  {
    super.initState();
    initClass();
  }

  void initClass() async
  {
    if(Loaded.tests==null||!Loaded.loadedTestsOnce){
      /// reload the tests only when
      /// the Loaded.tests are null
      /// or they pull down to refresh
      Loaded.tests = await MoFirebase.getTests(MoFirebase.getTestsBasicRef(),Test.TESTS_BASIC);
      print("loading tests");
      Loaded.loadedTestsOnce = true;
    }

    if(mounted){
      setState(() {

      });
    }


  }


  Widget getGuide()
  {
    String guide = "";
    if(widget.mode==null){
      guide = Test.TEST_GUIDE_START;
    }else{
      switch(widget.mode)
      {
        case Test.TESTS_START_TEST:
          guide = Test.TEST_GUIDE_START;
          break;
        case Test.TESTS_SHOW_RESULTS:
          guide = Test.TEST_GUIDE_RESULT;
          break;
        default:
          guide = Test.TEST_GUIDE_START;
          break;
      }
    }

    return new Text(
      guide,
      style: new TextStyle(color: Colors.black87),
    );

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MoColor.canvasColor,
            resizeToAvoidBottomPadding: true,
            body: RefreshIndicator(
                onRefresh: refreshTests,
                child: MoSliver(
                  padding: MoPadding(
                    paddingTop: 2,
                  ),

                  appBar: MoSliverAppBar(
                    backgroundHasOpacity: false,
                    floating: true,
                    snap: true,
                    backgroundColor: MoColor.canvasColor,
                    flexibleSpace: MoSliverAppBars.getFlexibleSpace(context,"Assesments", widget.title,MoColor.canvasColor),
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
    Loaded.tests = await MoFirebase.getTests(MoFirebase.getTestsBasicRef(),Test.TESTS_BASIC,forceRefresh: true);
    setState(() {
      print("refreshed");
    });
  }



  List<Widget> getBody(BuildContext context)
  {
    List<Widget> widgets = new List();

    if(Loaded.tests != null){
      if(Loaded.tests.length==0){
        widgets.add(MoUseFullWidgets.loading());
      }else{
        for(int i = 0;i<Loaded.tests.length;i++){
          if(!Loaded.tests.values.toList()[i].isPrivate()){
            widgets.add(Loaded.tests.values.toList()[i].toShowTestsWidget(context,widget.mode));
          }
        }
      }
    }else{
      widgets.add(Helpers.loading());
    }
    return widgets;
  }



  search()
  {
    if(Loaded.tests != null){

      showSearch(context: context, delegate: SearchATest(Loaded.tests.values.toList(),widget.mode,isFromShowTests: true));
    }else{
      print("we can not until it is downloaded");
    }
  }
  
  




}

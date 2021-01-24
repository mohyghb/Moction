import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/MoWidgets/MoDialog.dart';
import 'package:moction/MoWidgets/MoPadding.dart';
import 'package:moction/MoWidgets/MoPdf.dart';
import 'package:moction/MoWidgets/MoPopUpMenu.dart';
import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Patient/ShowAllPatients.dart';

import 'package:moction/Test/Program.dart';

import 'package:moction/Show/LoadATest.dart';
import 'package:moction/Show/ShowResultsTest.dart';
import 'package:moction/Test/ProgramResult.dart';
import 'package:moction/Test/Result.dart';
import 'package:moction/MoWidgets/MoLoadingScreen.dart';
import 'package:moction/MoWidgets/MoButton.dart';
import 'package:moction/MoWidgets/MoPageView.dart';
import 'package:moction/Test/Test.dart';

// ignore: must_be_immutable
class ShowAllResultsOfAProgram extends StatefulWidget {
  Program program;

  ShowAllResultsOfAProgram(this.program);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ShowAllResultsOfAProgramState();
  }
}

class ShowAllResultsOfAProgramState extends State<ShowAllResultsOfAProgram> {
  bool showLoading;

  MoLoadingScreen loadingScreen;

  List<ProgramResult> results;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.showLoading = true;
    loadingScreen = new MoLoadingScreen(
        Duration(milliseconds: 1500), Duration(milliseconds: 600));

    loadResults();
  }

  loadResults() async {
    widget.program.getResultsFromCloud().then((val) {
      if (val != null && mounted) {
        print('this is happening');
        setState(() {
          this.results = val;
          this.showLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return getBody(context);
  }

  Widget getBody(BuildContext context) {
    //showLoading = false;
    //print(ShowATest.test.subs[0].subId);
    if (this.results == null) {
      return loadingScreen;
    } else if (this.results.isEmpty) {
      return new Text("no results");
    }
    return  Scaffold(
        backgroundColor: MoColor.canvasColor,
        resizeToAvoidBottomPadding: true,
        body: Builder(
          builder: (context) {
            return MoSliver(
              padding: MoPadding(
                paddingAll: 0,
              ),
              bouncingScrollPhysics: true,
              appBar: MoSliverAppBar(
                backgroundHasOpacity: true,
                backgroundColor: MoColor.canvasColor,
                actions: <Widget>[],
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    MoSliverAppBars.centeredFlexSpace(
                      MoTexts.titleText(context, "Saved Results", MoColor.canvasColor,
                          align: TextAlign.center),
                    ),
                    getPdfButton(context),
                  ],
                ),
              ),
              widgets: this.getWidgets(),
//          widgets: <Widget>[
//            getStepper(),
////            ShowAProgram.program.getTests(context)
//          ],
            );
          },
        ),
    );
  }

  Widget getPdfButton(BuildContext context) {
    return new RaisedButton(
      onPressed: () {
        MoPdf.createPdfProgramResults(widget.program, context);
      },
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            ),
            new SizedBox(
              width: 10.0,
            ),
            new Text(
              "Create Pdf",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    List<Widget> w = new List();

    for (ProgramResult pr in this.results) {
      w.add(pr.toWidget(context, ProgramResult.BASIC));
    }
    return w;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //ShowATest.result = null;
  }
}

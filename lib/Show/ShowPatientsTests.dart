/// needs to be tested more
///
///
import 'package:flutter/material.dart';
import 'package:moction/MoWidgets/MoColor.dart';
import 'package:moction/MoWidgets/MoPdf.dart';

import 'package:moction/MoWidgets/MoSliver.dart';
import 'package:moction/MoWidgets/MoSliverAppBar.dart';
import 'package:moction/MoWidgets/MoTexts.dart';
import 'package:moction/Loaded.dart';
import 'package:moction/Helpers.dart';
import 'package:moction/Test/Test.dart';
import 'package:moction/Patient/Patient.dart';

class ShowPatientsTests extends StatefulWidget {
  @override
  _ShowPatientsTestsState createState() => _ShowPatientsTestsState();
}

class _ShowPatientsTestsState extends State<ShowPatientsTests> {
  /// add the ability to get all the results of the chosen
  /// ones

  Test test;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initClass();
  }

  void initClass() async {
    test = await Patient.currentPatient.loadNormalResult(Loaded.currentTest);
    test.title = Loaded.currentTest.title;
    test.description = Loaded.currentTest.description;

    if (mounted) {
      setState(() {});
    }
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoColor.canvasColor,
      body: Builder(
        builder: (context) {
          return MoSliver(
            appBar: MoSliverAppBar(
              backgroundColor: MoColor.canvasColor,
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                            child: MoTexts.titleText(context, "Saved Results",
                                MoColor.canvasColor)),
                        getPdfButton(context)
                      ],
                    )),
              ),
            ),
            widgets: getBody(context),
          );
        },
      ),
    );
  }


  Widget getPdfButton(BuildContext context)
  {
    return new RaisedButton(
      onPressed: () {
        MoPdf.createPdfResults(test, context);
      },
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Icon(Icons.picture_as_pdf,color: Colors.white,),
            new SizedBox(
              width: 10.0,
            ),
            new Text("Create Pdf",style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }

  List<Widget> getBody(BuildContext context) {
    List<Widget> widgets = new List();
    if (Loaded.tests != null) {
      if (Loaded.tests.length == 0) {
        widgets.add(new Text("no test found"));
      } else {
        if (this.test != null) {
          widgets = this.test.savedResultsWidget(context);
        }
      }
    } else {
      widgets.add(Helpers.loading());
    }
    return widgets;
  }
}

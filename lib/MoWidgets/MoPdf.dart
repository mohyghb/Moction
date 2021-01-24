import 'dart:io';

import 'package:moction/MoStopWatch/FormatTime.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/ReactionTime/Elapsed.dart';
import 'package:moction/ReactionTime/ReactionTime.dart';
import 'package:moction/Test/ProgramResult.dart';
import 'package:moction/Test/Result.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:moction/Test/Tools.dart';
import 'package:moction/Test/Test.dart';
import 'package:moction/Test/SubTest.dart';
import 'package:moction/Test/Program.dart';

import 'package:moction/Helpers.dart';
import 'dart:io' as Io;

class MoPdf {
  static String nameOfPdf = "newPDF";
  static String patientName = "patientId";
  static String nameOfTheTestOrProgram = "name of the test or program";

  static const String nameOfFolder = "Moction Files";
  static const String RESULTS = "Results";

  static int mode = 1;
  static const String TESTS = "Tests";
  static const String PROGRAMS = "Programs";

  static Document pdf;

  static void createPdfTest(Test test, var context) async {
    final Document pdf = Document(
//        deflate: zlib.encode
        );
    try {
      pdf.addPage(MultiPage(build: (context) {
        return TestPdf.makePdfForTest(test, context, true);
      }));
      Helpers.showSnackBar(
          "Pdf file was created for ${test.title}", false, context);
    } catch (e) {
      Helpers.showSnackBar(
          "Sorry something went wrong, we could not make a Pdf file. Try again later or call support.",
          true,
          context);
    }

    mode = Test.TEST;
    writeWithPermission(pdf.save(),false);
  }

  static void createPdfProgram(Program program, var context) async {
    final Document pdf = Document(
//        deflate: zlib.encode
        );
    try {
      pdf.addPage(MultiPage(build: (context) {
        return ProgramPdf.makePdfForProgram(context, program);
      }));
      Helpers.showSnackBar(
          "Pdf file was created for ${program.title}", false, context);
    } catch (e) {
      Helpers.showSnackBar(
          "Sorry something went wrong, we could not make a Pdf file. Try again later or call support.",
          true,
          context);
    }
    mode = Program.PROGRAM;

    writeWithPermission(pdf.save(),false);
  }

  static String getString(String text) {
    return text.replaceAll(RegExp(r"[^\s\w\.:?±]"), "");
  }

  static writeWithPermission(List<int> pdf,bool resultEdition) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.storage]).then(
                (Map<PermissionGroup, PermissionStatus> granted) {
      granted.forEach((PermissionGroup pg, PermissionStatus ps) {
        if (pg == PermissionGroup.storage && ps == PermissionStatus.granted) {
          print("permission was granted");
          writePdf(pdf,resultEdition);
        } else {
          print("permission denied");
        }
      });
    });
  }

  static Future<File>  _localFile(bool resultEdition) async {
    final path = await _localPath;

    final folder = resultEdition? await everyDirectoryExists_ResultEdition(path):await everyDirectoryExists(path);

//    final testdir =
//        await new Io.Directory('$path/iLearn').create(recursive: true);

    return Io.File('${folder.path}/$nameOfPdf.pdf');
  }

  static Directory getDirectory(String path) {
    Directory dir = new Io.Directory('$path');
    return dir;
  }

  static Future<Directory> everyDirectoryExists(String esPath) async {
    final folder = getDirectory(
        '$esPath/$nameOfFolder/$patientName/${getMode()}/$nameOfTheTestOrProgram');
    bool folderExists = await folder.exists();
    if (!folderExists) {
      final newFolder = await folder.create(recursive: true);
      return newFolder;
    }
    return folder;
  }


  static Future<Directory> everyDirectoryExists_ResultEdition(String esPath) async {
    final folder = getDirectory(
        '$esPath/$nameOfFolder/$patientName/${getMode()}/$nameOfTheTestOrProgram/$RESULTS');
    bool folderExists = await folder.exists();
    if (!folderExists) {
      final newFolder = await folder.create(recursive: true);
      return newFolder;
    }
    return folder;
  }

  static String getMode() {
    switch (mode) {
      case Test.TEST:
        return TESTS;
      case Program.PROGRAM:
        return PROGRAMS;
    }
    return null;
  }

//  createIfNotExist(bool exist,Directory dir)
//  {
//    if(!exist){
//      dir.crea
//    }
//  }

  static Future<File> writePdf(List<int> pdf,bool resultEdition) async {
    final file = await _localFile(resultEdition);

    File result = await file.writeAsBytes(pdf);
    if (result == null) {
      print("Writing to file failed");
    } else {
      print("Successfully writing to file");
    }
    return result;
  }

  static Future<String> get _localPath async {
    final externalDirectory = await getExternalStorageDirectory();
    return externalDirectory.path;
  }

  /// create a pdf for a list of results
  static void createPdfResults(Test test, var context) async {
    final Document pdf = Document(
//        deflate: zlib.encode
        );
    try {
      pdf.addPage(MultiPage(build: (context) {
        return

            /// title of the test

            PdfWidgets.getTableForResults(context, test);
      }));
      Helpers.showSnackBar(
          "Pdf file was created for ${test.title}", false, context);
    } catch (e) {
      Helpers.showSnackBar(
          "Sorry something went wrong, we could not make a Pdf file. Try again later or call support.",
          true,
          context);
    }

    mode = Test.TEST;
    patientName = Patient.currentPatient.fullName;
    nameOfTheTestOrProgram = test.title;
    nameOfPdf = "Results"  + DateTime.now().toIso8601String();
    writeWithPermission(pdf.save(),true);
  }



  static void createPdfProgramResults(Program program, var context) async {
    final Document pdf = Document(
//        deflate: zlib.encode
    );
    try {
      pdf.addPage(MultiPage(build: (context) {
        return

          /// title of the test

          PdfWidgets.getTableForProgramResults(context, program);
      }));
      Helpers.showSnackBar(
          "Pdf file was created for ${program.title}", false, context);
    } catch (e) {
      Helpers.showSnackBar(
          "Sorry something went wrong, we could not make a Pdf file. Try again later or call support.",
          true,
          context);
    }

    mode = Program.PROGRAM;
    patientName = Patient.currentPatient.fullName;
    nameOfTheTestOrProgram = program.title;
    nameOfPdf = "Results"  + DateTime.now().toIso8601String();
    writeWithPermission(pdf.save(),true);
  }














}

class PdfWidgets {
  static const double SMALL_WIDTH_SPACE = 4;
  static const double SMALL_SQUARE_SIDE = 10;

  static Widget getChecker(String text, bool isChecked, PdfColor checkedColor) {
    return Row(children: <Widget>[
      Container(
        width: SMALL_SQUARE_SIDE,
        height: SMALL_SQUARE_SIDE,
        decoration: BoxDecoration(
          color: (isChecked) ? checkedColor : PdfColors.white,
          border: BoxBorder(
              left: true,
              right: true,
              bottom: true,
              top: true,
              color: PdfColors.black),
        ),
      ),
      SizedBox(width: SMALL_WIDTH_SPACE),
      Text(text),
    ]);
  }

  static Widget getButton(String text, bool wasPressed, PdfColor color) {
    if(!wasPressed){
      return new Text(text, style: TextStyle(color: PdfColors.black));
    }
    return Container(
        width: double.infinity,
        decoration: !wasPressed
            ? null
            : BoxDecoration(
                border: BoxBorder(
                    left: true,
                    right: true,
                    bottom: true,
                    top: true,
                    color: (wasPressed) ? color : PdfColors.white),
              ),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: new Text(text, style: TextStyle(color: PdfColors.black))));
  }

  static Widget getTableForReactionTimes(
      Context context, ReactionTime reactionTime) {
    List<List<String>> loss = new List();
    int index = 1;

    if (reactionTime.content.reactionsTimes.isNotEmpty) {
      List<String> titles = new List();
      titles.add("Index");
      titles.add("Reaction Time");
      titles.add("Status");

      loss.add(titles);
    }

    for (Elapsed elapsed in reactionTime.content.reactionsTimes) {
      if (index < 21) {
        List<String> los = new List();
        los.add(index.toString());
        los.add(elapsed.reactionTime.toString());
        los.add(elapsed.status);
        loss.add(los);
        index++;
      }
    }

    if (loss.isEmpty) {
      return SizedBox();
    }
    if (index >= 21) {
      return Column(children: <Widget>[
        new Table.fromTextArray(
          context: context,
          data: loss,
        ),
        PdfWidgets.getButton(
            "It is important to note that only the first 20 reaction times have been recorded inside this table",
            true,
            PdfColors.red)
      ]);
    } else {
      return new Table.fromTextArray(
        context: context,
        data: loss,
      );
    }
  }

//  static Widget getCard(List<Widget> children)
//  {
//    return Stack(
//      children: [
//        Container(color: PdfColors.red),
//        Column(
//          children: children
//        )
//      ]
//    );
//  }

  static Widget getHorizontalLine(double height, PdfColor color) {
    return new Container(height: height, color: color);
  }

  static List<Widget> getTableForResults(Context context, Test test) {
    List<Widget> ws = new List();
//    List<List<String>> loss = new List();
//    int index = 1;
//
//    List<String> titles = new List();
//    titles.add("Index");
//    titles.add("Date");
//    titles.add("Time");
//    titles.add("Result");

    //loss.add(titles);

    ws.add(PdfWidgets.informationWidget());
    ws.add(Text(
      test.title,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ));

    /// description of the test
    ws.add(Paragraph(
        text: MoPdf.getString(test.description), textAlign: TextAlign.center));

    int index = 0;
    for (Result result in test.savedResults) {
      if (index != 0) {
        ws.add(PdfWidgets.getHorizontalLine(2, PdfColors.black));
      }
      ws.add(SizedBox(height: 10.0));
      ws.add(Text("Test: " + result.test.title));
      ws.add(Text("Date: " + result.getDate()));
      ws.add(Text("Time: " + result.getTime()));
      ws.add(Text("Result: " + result.result));
      index++;
      if (index != test.savedResults.length) {
        ws.add(SizedBox(height: 10.0));
      }
    }

    return ws;
  }


  static List<Widget> getTableForProgramResults(Context context, Program program) {
    List<Widget> ws = new List();
//    List<List<String>> loss = new List();
//    int index = 1;
//
//    List<String> titles = new List();
//    titles.add("Index");
//    titles.add("Date");
//    titles.add("Time");
//    titles.add("Result");

    //loss.add(titles);

    ws.add(PdfWidgets.informationWidget());
    ws.add(Text(
      program.title,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ));

    /// description of the test
    ws.add(Paragraph(
        text: MoPdf.getString(program.description), textAlign: TextAlign.center));

    int index = 0;
    for (ProgramResult result in program.savedProgramResults) {
      if (index != 0) {
        ws.add(PdfWidgets.getHorizontalLine(2, PdfColors.black));
      }
      ws.add(SizedBox(height: 10.0));
      ws.add(Text("Date: " + result.getDate()));
      ws.add(Text("Time: " + result.getTime()));
      ws.add(Text("Result: " + result.result));
      index++;
      if (index != program.savedProgramResults.length) {
        ws.add(SizedBox(height: 10.0));
      }
    }

    return ws;
  }


  static Widget informationWidget() {
//    subject: ,
//    title: "Moction",
//    creator: "Moh Yaghoub",
//  author: patientName,
//  producer: DateTime.now().toIso8601String()
    return Container(
        decoration: BoxDecoration(
            border: BoxBorder(
                left: true,
                right: true,
                top: true,
                bottom: true,
                color: PdfColors.black),
            color: PdfColors.white),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("Moction"),
                  new Text("Patient: " + MoPdf.patientName),
                  new Text(
                      "Date: " + DateTime.now().toIso8601String().split("T")[0])
                ])));
  }
}

class ProgramPdf {
  static List<Widget> makePdfForProgram(Context context, Program program) {
    List<Widget> widgets = new List();
    widgets.add(PdfWidgets.informationWidget());
    for (Test test in program.activeTests) {
      widgets.addAll(TestPdf.makePdfForTest(test, context, false));
    }

    widgets.add(PdfWidgets.getButton(MoPdf.getString(
        "Result of ${program.title}: " + MoPdf.getString(program.getResult().toString())), true, PdfColors.blue));

    return widgets;
  }
}

class TestPdf {
  static List<Widget> makePdfForTest(
      Test test, Context context, bool includeResults) {
    List<Widget> ws = new List();

    if (includeResults) {
      /// then we are making a pdf for a program
      ws.add(PdfWidgets.informationWidget());
    }

    /// title of the test
    ws.add(Text(
      test.title,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ));

    /// description of the test
    ws.add(Paragraph(
        text: MoPdf.getString(test.description), textAlign: TextAlign.center));

    int index = 1;
    for (SubTest subTest in test.subs) {
//      if(index==1){
      ws.add(PdfWidgets.getHorizontalLine(2, PdfColors.black));
      ws.add(SizedBox(height: 10));
      // }
      ws.addAll(SubTestPdf.getSubWidget(subTest, context));
      ws.add(SizedBox(height: 10));
//      ws.add(PdfWidgets.getHorizontalLine(2, PdfColors.black));
//      ws.add(SizedBox(height: 10));
      index++;
    }

    ws.add(SizedBox(height: 20));

    if (includeResults) {
      ws.add(PdfWidgets.getButton(MoPdf.getString(
          "Result of ${test.title}: " + test.getResults().toString()), true, PdfColors.blue));
    }

    return ws;
  }
}

class SubTestPdf {
  static List<Widget> getSubWidget(SubTest subTest, Context context) {
    List<Widget> ts = new List();
    ts.add(Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child:Text(subTest.title, style: TextStyle(fontWeight: FontWeight.bold))));
    ts.add(Paragraph(
          padding: EdgeInsets.only(left: 8.0,right: 8.0),
        text: MoPdf.getString(subTest.description), textAlign: TextAlign.left));
    // print(subTest.description.replaceAll(RegExp(r"[^\s\w]"), ""));
    for (Tools tool in subTest.tools) {
      ts.add(Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
          child: ToolPdf.getToolWidget(tool, context)));
    }

    return ts;
  }
}

//.replaceAll(RegExp(r"[^\s\w]"), "")

class ToolPdf {
  /// takes a tool and
  /// produces a widget for it

  static Widget getToolWidget(Tools tool, Context context) {
    String text = MoPdf.getString(tool.tool.title);
    String ogText = MoPdf.getString(tool.tool.ogTitle);

    //print(text);

    switch (tool.typeOfTool) {
      case Tools.CHECKER:
        return PdfWidgets.getChecker(
            text, tool.tool.wasPressed, PdfColors.green);
        break;
      case Tools.BUTTON:
        return PdfWidgets.getButton(
            text, tool.tool.wasPressed, PdfColors.green);
        break;
      case Tools.SCORE:
        return PdfWidgets.getButton(
            ogText + ": " + text, true, PdfColors.green);
        break;
      case Tools.TIMER:
        return PdfWidgets.getButton(
            ogText + ": " + FormatTime.readableForm(text),
            true,
            PdfColors.green);
        break;
      case Tools.DATA:
        return PdfWidgets.getTableForReactionTimes(
            context, tool.tool.reactionTime);
        //print("span: " + span.canSpan.toString());
        break;
      case Tools.INPUT:
        return PdfWidgets.getButton(
            ogText + ": " + text, true, PdfColors.green);
        break;
      default:
        return new Paragraph(text: text);
        break;
    }
  }
}

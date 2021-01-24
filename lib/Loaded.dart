import 'package:moction/Test/Test.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/Test/Tools.dart';
import 'package:moction/Test/SubTest.dart';
import 'package:moction/Test/Program.dart';


class Loaded{

 // static List<Patient> patients;
 // static List<Test> tests;
  static List<Program> programs;
  static Map<String, Test> tests = new Map();
  static Map<String,Tools> tools = new Map();
  static Map<String,SubTest> subTests = new Map();

  static Test currentTest;
  static Program currentProgram;


  static bool loadedTestsOnce = false;

}
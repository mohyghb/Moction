import 'dart:math';
import 'package:moction/MoWidgets/MoNotNull.dart';

class MoId{


  static Random random = new Random.secure();

  static String generateRandomId({String unique, List<String> ids})
  {

    int randomId = random.nextInt(1000000000);
    int randomId1 = random.nextInt(1000000000);
    int randomId2 = random.nextInt(1000000000);

    String unique_1 = MoNotNull.string(unique);


    String id = unique_1 + randomId.toString()+randomId1.toString()+randomId2.toString();

    return id;
  }

}
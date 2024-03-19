
import 'package:shared_preferences/shared_preferences.dart';

class SaveDataController{
  static String? score;

  static Future<bool> saveUserScore(String score) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('score', score);
      return true; // Return true if saving is successful
    } catch (e) {
      print('Error saving user score: $e');
      return false; // Return false if there's an error
    }
  }

  static Future<String?> getUserScore() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('score');
  }

}


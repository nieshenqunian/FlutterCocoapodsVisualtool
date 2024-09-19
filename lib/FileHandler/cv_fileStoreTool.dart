import 'package:shared_preferences/shared_preferences.dart';

class CVFileStoreTool {
  static Future<bool> savePodDirectoryPath(String? path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (path == null || path == "") return false;
    return await prefs.setString('kPodDirectory', path);
  }

  static Future<String?> podDirectoryPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pdString = prefs.getString('kPodDirectory');
    return pdString;
  }
}
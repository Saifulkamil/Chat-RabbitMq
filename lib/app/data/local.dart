import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String dataProfile = 'DATA_PROFILE';
  static Future<String> getDataMe() async {
    final preferences = await SharedPreferences.getInstance();
    String? profileString = preferences.getString(dataProfile);
    return profileString!;
  }

  static Future<void> saveDataProfile(String data) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(dataProfile, data);
  }
}

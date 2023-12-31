import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _keySwitch = 'switch';
  static const _keyPets = 'pets';
  static const _keyBirthday = 'birthday';
  static const _keyImage = 'image';
  static const _keyImageList = 'imageList';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  // String Date
  static Future saveUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static String? getUsername() => _preferences.getString(_keyUsername);

  // Bool Date
  static Future saveSwitch(bool value) async =>
      await _preferences.setBool(_keySwitch, value);

  static bool? getSwitch() => _preferences.getBool(_keySwitch);

  // List Date
  static Future savePets(List<String> pets) async =>
      await _preferences.setStringList(_keyPets, pets);

  static List<String>? getPets() => _preferences.getStringList(_keyPets);

  // DateTime Date
  static Future saveBirthday(DateTime dateOfBirth) async {
    final birthday = dateOfBirth.toIso8601String();

    return await _preferences.setString(_keyBirthday, birthday);
  }

  static DateTime? getBirthday() {
    final birthday = _preferences.getString(_keyBirthday);

    return birthday == null ? null : DateTime.tryParse(birthday);
  }

  // String Image File
  static Future saveImage(String path) async =>
      await _preferences.setString(_keyImage, path);

  static String? getImage() => _preferences.getString(_keyImage);

  // Image List Date
  static Future saveImageList(List<String> path) async =>
      await _preferences.setStringList(_keyImageList, path);

  static List<String>? getImageList() => _preferences.getStringList(_keyImageList);
}

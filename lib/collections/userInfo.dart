import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  int id;
  String name;
  String email;
  String type;
  UserInfo(this.id, this.name, this.email, this.type);
}

setUserInfo({required int id, required String name, required String email, required String type}) async {
  final pref = await SharedPreferences.getInstance();
  pref.setInt('userId', id);
  pref.setString('userName', name);
  pref.setString('userEmail', email);
  pref.setString('userType', type);
}

Future<UserInfo> getUserInfo() async {
  final pref = await SharedPreferences.getInstance();
  int id = pref.getInt('userId') ?? 0;
  String name = pref.getString('userName') ?? '';
  String email = pref.getString('userEmail') ?? '';
  String type = pref.getString('userType') ?? '';

  return UserInfo(id, name, email, type);
}
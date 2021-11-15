import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  int id;
  String name;
  String email;
  String type;
  String emoji;
  UserInfo(this.id, this.name, this.email, this.type, this.emoji);
}

setUserInfo({required int id, required String name, required String email, required String type, required String emoji}) async {
  final pref = await SharedPreferences.getInstance();
  pref.setInt('userId', id);
  pref.setString('userName', name);
  pref.setString('userEmail', email);
  pref.setString('userType', type);
  pref.setString('userEmoji', emoji);
}

Future<UserInfo> getUserInfo() async {
  final pref = await SharedPreferences.getInstance();
  int id = pref.getInt('userId') ?? 0;
  String name = pref.getString('userName') ?? '';
  String email = pref.getString('userEmail') ?? '';
  String type = pref.getString('userType') ?? '';
  String emoji = pref.getString('userEmoji') ?? '';

  return UserInfo(id, name, email, type, emoji);
}
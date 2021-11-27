import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/userInfo.dart';
import 'package:vocalist/restApi/loginApi.dart';

import '../main.dart';

vloomLogin(String email, String type) async {
  var loginResponse = await loginApi(email: email, type: type);
  if(loginResponse == null) {
    showToast('error');
  }
  else {
    print(loginResponse);
    if(loginResponse['exist'] == true) {
      if(loginResponse['data']['type'] != type) {
        print('이미 다른 소셜 로그인 가입이 되어있는 이메일입니다.');
        showToast('이미 다른 소셜 로그인 가입이 되어있는 이메일입니다.');
        return true;
      }
      else {
        loginPref(loginResponse['data']);
        showToast('안녕하세요, ${loginResponse['data']['name']}님!');
        return true;
      }
    }
  }
  return false;
}

loginPref(dynamic userData) async {
  final pref = await SharedPreferences.getInstance();
  pref.setBool('isLogin', true);
  await setUserInfo(
    id: userData['id'],
    name: userData['name'],
    email: userData['email'],
    type: userData['type'],
    emoji: userData['emoji']
  );

  userInfo = await getUserInfo();
}
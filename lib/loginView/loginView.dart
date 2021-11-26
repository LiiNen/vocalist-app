import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/userInfo.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/mainNavView.dart';
import 'package:vocalist/restApi/loginApi.dart';

import 'googleLoginView.dart';
import 'appleLoginView.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginView();
}
class _LoginView extends State<LoginView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: MainAppBar(title: 'login'),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GoogleLoginView(),
              AppleLoginView(),
            ]
          )
        )
      )
    );
  }

  void testerLogin() async {
    var state = await _loginPref();
    if(state) navigatorPush(context: context, widget: MainNavView(), replacement: true, all: true);
  }

  _loginPref() async {
    var response = await loginApi(email: 'test@vloom.co.kr', type: 'google');
    if(response != null) {
      final pref = await SharedPreferences.getInstance();
      pref.setBool('isLogin', true);
      await setUserInfo(id: response['data']['id'], name: response['data']['name'], email: response['data']['email'], type: response['data']['type'], emoji: response['data']['emoji']);
      userInfo = await getUserInfo();
      print(userInfo.id);
      print(userInfo.name);
      print(userInfo.emoji);
      return true;
    }
    return false;
  }
}
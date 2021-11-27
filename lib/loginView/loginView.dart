import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
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

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 1), _setVisible);
  }

  void _setVisible() {
    setState(() {
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 21, vertical: MediaQuery.of(context).size.height * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              vloomLogo(),
              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: socialLogin()
              )
            ]
          )
        )
      )
    );
  }

  vloomLogo() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, bottom: 10),
          child: Image.asset('asset/image/logo_50.png', height: 60)
        ),
        Text('음역대 분석 노래방 서비스', style: textStyle(weight: 600, size: 18.0))
      ]
    );
  }

  socialLogin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
      child: Column(
        children: [
          Container(
            height: 18,
            margin: EdgeInsets.only(bottom: 16),
            child: Stack(
              children: [
                Center(child: lineDivider(context: context, color: Color(0xffbebebe))),
                Center(
                  child: Container(
                    width: 76,
                    color: Colors.white,
                    child: Text('소셜 로그인', style: textStyle(color: Color(0xffbebebe)), textAlign: TextAlign.center,),
                  ),
                )
              ]
            )
          ),
          GoogleLoginView(),
          SizedBox(height: 20),
          AppleLoginView(),
        ]
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
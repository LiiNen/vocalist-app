import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vocalist/collections/function.dart';
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
    return PopScope(
      onPopInvoked: (dipPop) {
        onWillPop(context);
      },
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
          child: Image.asset('asset/image/splashLogo.png', height: 60)
        ),
        Text('노래방 필수 어플리케이션', style: textStyle(weight: 600, size: 18.0))
      ]
    );
  }

  socialLogin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Text('소셜로그인', style: textStyle(color: Color(0xffbebebe), size: 12.0), textAlign: TextAlign.center,),
                  ),
                )
              ]
            )
          ),
          GoogleLoginView(),
          SizedBox(height: 20),
          AppleLoginView(),
          SizedBox(height: 6),
          Text('Apple 로그인의 경우 이메일 공유를 하지 않을 경우 원활한 서비스 이용이 불가할 수 있습니다.', style: textStyle(color: Color(0xffbebebe), size: 12.0))
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
      return true;
    }
    return false;
  }
}
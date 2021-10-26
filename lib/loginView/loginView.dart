import 'package:flutter/material.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/userInfo.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/mainNavView.dart';
import 'package:vocalist/restApi/loginApi.dart';

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
              SignInButton(Buttons.Google, onPressed: googleLogin),
              SignInButton(Buttons.Apple, onPressed: appleLogin)
            ]
          )
        )
      )
    );
  }

  void googleLogin() async {
    _loginPref();
    navigatorPush(context: context, widget: MainNavView(), replacement: true, all: true);
  }

  void appleLogin() async {
    await Firebase.initializeApp();

    final _firebaseAuth = FirebaseAuth.instance;
    List<Scope> scopes = [Scope.email, Scope.fullName];

    if(await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch(result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken: String.fromCharCodes(appleIdCredential.authorizationCode)
          );
          final authResult = await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = authResult.user!;
          if(firebaseUser.displayName == null) {
            await firebaseUser.updateDisplayName('${appleIdCredential.fullName.familyName}${appleIdCredential.fullName.givenName}');
          }

          var loginData = await loginApi(email: firebaseUser.email!, type: 'apple');
          if(loginData == null) {
            //todo: handling message
            print('please check network');
          }
          else {
            if(loginData['exist']) {
              //isLogin['data'] 정보 로컬에 저장
              print('로그인 되었습니다.');
            }
            else {
              var signupData = await signupAction(email: firebaseUser.email!, name: firebaseUser.displayName!, type: 'apple');
              if(signupData == null) {
                print('please check network');
              }
              else {
                print(signupData['body']); // 정보 로컬에 저장
              }
            }
          }

          break;
        case AuthorizationStatus.error:
          print('error');
          break;
        case AuthorizationStatus.cancelled:
          print('cancel');
          break;
      }
    }
  }

  void _loginPref() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('isLogin', true);
    setUserInfo(id: 1, name: '김정훈', email: 'test@vloom.co.kr', type: 'google');
    userInfo = await getUserInfo();
    print(userInfo.id);
    print(userInfo.name);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/loginView/signUpConfirmView.dart';
import 'package:vocalist/loginView/vloomLogin.dart';
import 'package:vocalist/mainNavView/mainNavView.dart';
import 'package:vocalist/restApi/loginApi.dart';

class AppleLoginView extends StatefulWidget {
  @override
  State<AppleLoginView> createState() => _AppleLoginView();
}
class _AppleLoginView extends State<AppleLoginView> {
  @override
  Widget build(BuildContext context) {
    return SignInButton(Buttons.Apple, onPressed: appleLogin);
  }

  void appleLogin() async {
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

          var loginResponse = await vloomLogin(firebaseUser.email!, 'apple');

          if(loginResponse) {
            final pref = await SharedPreferences.getInstance();
            if(pref.getBool('isLogin')!) {
              navigatorPush(context: context, widget: MainNavView(), replacement: true, all: true);
            }
          }
          else {
            var _confirm = await showSignUpConfirmDialog(context);
            if(_confirm) {
              var signUpResponse = await signupAction(email: firebaseUser.email!, name: firebaseUser.displayName!, type: 'apple');
              if(signUpResponse == null) {

              }
              else {
                if (signUpResponse['id'] == 0) {
                  showToast('이미 가입된 아이디입니다.');
                }
                showToast('회원가입이 완료되었습니다!');
              }
            }
            else {
              showToast('회원가입이 취소되었습니다.');
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
}
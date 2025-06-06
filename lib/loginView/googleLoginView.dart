// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/mainNavView/mainNavView.dart';

class GoogleLoginView extends StatefulWidget {
  @override
  State<GoogleLoginView> createState() => _GoogleLoginView();
}
class _GoogleLoginView extends State<GoogleLoginView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: googleLogin,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset('asset/image/signInGoogle.png')
      )
    );
  }

  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  void googleLogin() async {
    navigatorPush(context: context, widget: MainNavView(notice: true), replacement: true, all: true);
    // final GoogleSignInAccount? account = await googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth = await account!.authentication;
    //
    // final AuthCredential credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );
    //
    // final authResult = await _firebaseAuth.signInWithCredential(credential);
    // final firebaseUser = authResult.user!;
    //
    // assert(!firebaseUser.isAnonymous);
    // assert(await firebaseUser.getIdToken() != null);
    //
    // await googleSignIn.signOut();
    //
    // var loginResponse = await vloomLogin(firebaseUser.email!, 'google');
    // if(loginResponse) {
    //   final pref = await SharedPreferences.getInstance();
    //   if(pref.getBool('isLogin')!) {
    //     navigatorPush(context: context, widget: MainNavView(notice: true), replacement: true, all: true);
    //   }
    // }
    // else {
    //   var _confirm = await showSignUpConfirmDialog(context);
    //   if(_confirm) {
    //     var signUpResponse = await signupAction(email: firebaseUser.email!, name: firebaseUser.displayName!, type: 'google');
    //     if(signUpResponse == null) {
    //       showToast('다시 시도해주세요');
    //     }
    //     else {
    //       if (signUpResponse['id'] == 0) {
    //         showToast('이미 가입된 아이디입니다.');
    //       }
    //       showToast('회원가입 완료! 다시 로그인해주세요');
    //     }
    //   }
    //   else {
    //     showToast('회원가입이 취소되었습니다.');
    //   }
    // }
  }
}
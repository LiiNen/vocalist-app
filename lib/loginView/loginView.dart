import 'package:flutter/material.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:vocalist/collections/statelessWidget.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginView();
}
class _LoginView extends State<LoginView> {

  @override
  void initState() {
    super.initState();
    appleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: 'login'),
    );
  }

  // https://kyungsnim.net/160 애플로그인 재구현 필요
  void appleLogin() async {

    await Firebase.initializeApp();

    final _firebaseAuth = FirebaseAuth.instance;
    List<Scope> scopes = [Scope.email, Scope.fullName];

    // final credential = await SignInWithApple.getAppleIDCredential(
    //   scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName,
    //   ],
    //   webAuthenticationOptions: WebAuthenticationOptions(
    //     clientId: 'kr.co.vloom.app.vocalist',
    //     redirectUri: Uri.parse(
    //       'https://vloom-a19e7.firebaseapp.com/__/auth/handler',
    //     ),
    //   ),
    // );
    // print(credential);

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
          final firebaseUser = authResult.user;
          print(firebaseUser);
          if(firebaseUser!.displayName == null) {
            await firebaseUser!.updateDisplayName('${appleIdCredential.fullName.familyName}${appleIdCredential.fullName.givenName}');
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
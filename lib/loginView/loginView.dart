import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
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

  void appleLogin() async {
    List<Scope> scopes = [Scope.email, Scope.fullName];

    if(await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch(result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential);
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

navigatorPush({required BuildContext context, required Widget route, bool isReplace=false}) {
  isReplace
    ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route))
    : Navigator.push(context, MaterialPageRoute(builder: (context) => route));
}

Future<bool> onWillPop(BuildContext context) async {
  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Vloom 종료'),
      content: Text('Vloom을 종료하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => SystemNavigator.pop(),
          child: Text('Yes'),
        ),
      ],
    ),
  )) ?? false;
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

navigatorPush({required context, required widget, replacement=false, all=false}) {
  replacement
    ? all
      ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget), (route) => false)
      : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget))
    : Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
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

textFieldClear(TextEditingController controller) {
  controller.clear();
}
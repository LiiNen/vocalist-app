import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

showToast(String message) {
  Fluttertoast.showToast(msg: message,
    gravity: ToastGravity.BOTTOM,
  );
}

Future<bool> confirmDialog({required BuildContext context, required String title, required String content, required String firstMessage, required dynamic firstAction, required String secondMessage, required secondAction}) async {
  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: firstAction,
          child: Text(firstMessage),
        ),
        TextButton(
          onPressed: secondAction,
          child: Text(secondMessage),
        ),
      ],
    ),
  )) ?? false;
}

emojiToUnicode(String emoji) {
  return '0x${int.parse(emoji.runes.toString().replaceAll('(', '').replaceAll(')', '')).toRadixString(16).toString()}';
}

unicodeToEmoji(String target) {
  return String.fromCharCode(int.parse(target));
}
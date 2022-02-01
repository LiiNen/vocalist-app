import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vocalist/collections/statelessWidget.dart';

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
    builder: (context) => ConfirmDialog(
      title: 'vloom을 종료하시겠습니까?',
      positiveAction: () {SystemNavigator.pop();},
      negativeAction: () {},
      positiveWord: '종료',
      negativeWord: '취소'
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

showConfirmDialog(BuildContext context, Widget dialog) async {
  return (await showDialog(
    context: context,
    builder: (context) => dialog
  )) ?? false;
}

emojiToUnicode(String emoji) {
  return '0x${int.parse(emoji.runes.toString().replaceAll('(', '').replaceAll(')', '')).toRadixString(16).toString()}';
}

unicodeToEmoji(String target) {
  return String.fromCharCode(int.parse(target));
}
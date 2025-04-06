import 'package:flutter/material.dart';

TextStyle textStyle({color = const Color(0xff3c354d), weight = int, double size = 14.0, double spacing = 0}) {
  FontWeight fontWeight = FontWeight.normal;
  switch(weight) {
    case 400:
      fontWeight = FontWeight.w400;
      break;
    case 500:
      fontWeight = FontWeight.w500;
      break;
    case 600:
      fontWeight = FontWeight.w600;
      break;
    case 700:
      fontWeight = FontWeight.w700;
      break;
  }
  return TextStyle(
    color: color,
    fontWeight: fontWeight,
    fontFamily: "NotoSansCJKKR",
    fontStyle: FontStyle.normal,
    letterSpacing: spacing,
    fontSize: size
  );
}

Container lineDivider({required context, color=const Color(0xffe3e3e3), double margin=0}) {
  return Container(
    width: MediaQuery.of(context).size.width, height: 1,
    margin: EdgeInsets.symmetric(horizontal: margin),
    decoration: BoxDecoration(
      border: Border.all(
        color: color,
        width: 1
      )
    )
  );
}

textField({required controller, required focusNode, required hint, allowEnter=false, FocusNode? nextFocusNode}) {
  return TextField(
    controller: controller,
    autofocus: false,
    focusNode: focusNode,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10,),
      enabledBorder: enabledBorderDefault(),
      focusedBorder: focusedBorderDefault(),
      hintText: hint,
      hintStyle: textStyle(color: Color(0xffd1d5d9), weight: 400, size: 12.0),
    ),
    style: textStyle(weight: 600, size: 12.0),
    keyboardType: allowEnter ? TextInputType.multiline : TextInputType.text,
    textInputAction: allowEnter ? TextInputAction.newline : TextInputAction.done,
    maxLines: allowEnter ? 10 : 1,
    onSubmitted: (value) {
      if(allowEnter == false && nextFocusNode != null) nextFocusNode.requestFocus();
    },
  );
}

enabledBorderDefault() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Color(0xfff0f0f0), width: 1),
  );
}

focusedBorderDefault() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(2),
    borderSide: BorderSide(color: Color(0xff0958c5), width: 1),
  );
}
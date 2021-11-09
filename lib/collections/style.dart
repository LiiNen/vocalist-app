import 'package:flutter/material.dart';

TextStyle textStyle({color: const Color(0xff3c354d), weight: int, size: 14.0}) {
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
    fontSize: size
  );
}

Container lineDivider({required context, color=const Color(0xffe3e3e3)}) {
  return Container(
    width: MediaQuery.of(context).size.width, height: 1,
    decoration: BoxDecoration(
      border: Border.all(
        color: color,
        width: 1
      )
    )
  );
}
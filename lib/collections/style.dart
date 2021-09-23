import 'package:flutter/material.dart';

TextStyle textStyle({color: Colors.black, weight: int, size: 14.0}) {
  FontWeight fontWeight = FontWeight.normal;
  switch(weight) {
    case 400:
      fontWeight = FontWeight.w400;
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
    fontFamily: "AppleSDGothicNeo",
    fontStyle:  FontStyle.normal,
    fontSize: size
  );
}
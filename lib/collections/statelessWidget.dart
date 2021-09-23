import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  MainAppBar({this.title}) : preferredSize = Size.fromHeight(40.0);
  @override
  final Size preferredSize;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Container(
        child: Text(title != null ? title! : 'vloom', style: TextStyle(color: Colors.black),)
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:vocalist/collections/style.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  MainAppBar({this.title}) : preferredSize = Size.fromHeight(44.0);
  @override
  final Size preferredSize;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Container(
        child: Row(
          children: [
            Text(title != null ? title! : 'vloom', style: textStyle(weight: 700, size: 24.0)),
          ]
        )
      ),
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final bool back;
  DefaultAppBar({required this.title, this.back=false}) : preferredSize = Size.fromHeight(44.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            backButton(context),
            Text(title, style: textStyle(color: Colors.black, weight: 700, size: 15.0),),
            SizedBox(width: 32)
          ]
        )
      )
    );
  }
}

backButton(BuildContext context) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {Navigator.pop(context);},
    child: Container(
      width: 32,
      height: 32,
      child: Center(
        child: Icon(Icons.arrow_back, color: Colors.black)
      )
    )
  );
}

additionalButton({required String title, dynamic callback}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {if(callback != null) callback();},
    child: Container(
      width: 48, height: 21,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(11)),
        color: Color(0xfff6c873),
      ),
      child: Center(child: Text(title, style: textStyle(weight: 500, size: 10.0)))
    )
  );
}
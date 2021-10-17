import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  MainAppBar({this.title, this.back=false}) : preferredSize = Size.fromHeight(40.0);
  @override
  final Size preferredSize;
  final String? title;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            back ? backButton(context) : Container(),
            Text(title != null ? title! : 'vloom', style: TextStyle(color: Colors.black),),
            back ? SizedBox(width: 16) : Container()
          ]
        )
      ),
    );
  }

  backButton(BuildContext context) {
    return GestureDetector(
      onTap: () {Navigator.pop(context);},
      child: Container(
        width: 16,
        child: Center(
          child: Icon(Icons.arrow_back, color: Colors.black)
        )
      )
    );
  }

}
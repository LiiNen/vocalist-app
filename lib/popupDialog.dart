import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String content;
  final String date;

  PopupDialog({required this.title, required this.imageUrl, required this.content, required this.date});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: popupBox()
    );
  }

  popupBox() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          noticeImage(),
          noticeButton(),
        ]
      )
    );
  }

  noticeImage() {
    return Container(
      height: 200,
      child: AspectRatio(
        aspectRatio: 0.7,
        child: Image.network('https://raw.githubusercontent.com/LiiNen/LiiNen/main/images/github-blog/invention-Gyeongi.jpg')
      )
    );
  }

  noticeButton() {
    return Container();
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          noticeButtonBox(),
        ]
      )
    );
  }

  noticeImage() {
    return Container(
      height: 300,
      child: Image.network('https://raw.githubusercontent.com/LiiNen/LiiNen/main/images/github-blog/invention-Gyeongi.jpg',)
      // child: AspectRatio(
      //   aspectRatio: 0.7,
      //   child: Image.network('https://raw.githubusercontent.com/LiiNen/LiiNen/main/images/github-blog/invention-Gyeongi.jpg')
      // )
    );
  }

  noticeButtonBox() {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Row(
        children: [
          notSeeNoticeButton(),
          SizedBox(width: 20),
          notSeeNoticeButton(),
        ]
      )
    );
  }

  notSeeNoticeButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          notSeeNoticeButtonAction();
          // todo: navigator pop
        }
      )
    );
  }

  actionButton() {

  }

  notSeeNoticeButtonAction() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('notSeeNoticeDate', DateTime.now().toString());
  }
}
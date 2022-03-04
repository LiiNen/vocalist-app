import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/settingView/noticeView.dart';

class PopupDialog extends StatefulWidget {
  final dynamic notice;
  PopupDialog({required this.notice});

  @override
  State<PopupDialog> createState() => _PopupDialog();
}

class _PopupDialog extends State<PopupDialog> {

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
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        navigatorPush(context: context, widget: NoticeView(widget.notice));
      },
      child: Container(
        child: Image.network(widget.notice['image_url'] ?? 'https://raw.githubusercontent.com/LiiNen/LiiNen/main/images/vloom/vloom_splash.png',)
      )
    );
  }

  noticeButtonBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          notSeeNoticeButton(),
          SizedBox(width: 18),
          closeButton(),
        ]
      )
    );
  }

  notSeeNoticeButton() {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          notSeeNoticeButtonAction();
          Navigator.pop(context);
        },
        child: Container(
          height: 24,
          child: Center(
            child: Text('다시 보지 않기', style: textStyle(color: Colors.black, weight: 600, size: 18.0))
          )
        )
      )
    );
  }

  closeButton() {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          child: Center(
            child: Text('닫기', style: textStyle(color: Colors.black, weight: 600, size: 18.0))
          )
        )
      )
    );
  }

  notSeeNoticeButtonAction() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('notSeeNoticeDate', getToday());
  }
}
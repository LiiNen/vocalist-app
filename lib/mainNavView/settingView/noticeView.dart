import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeView extends StatelessWidget {
  final dynamic noticeItem;
  NoticeView(this.noticeItem);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: '공지사항', back: true),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6),
              textBox(text: noticeItem['title'], isTitle: true),
              SizedBox(height: 6),
              lineDivider(context: context),
              imageBox(noticeItem['image_url']),
              SizedBox(height: 12),
              textBox(text: noticeItem['content'], isTitle: false),
              SizedBox(height: 30),
            ]
          )
        )
      )
    );
  }

  textBox({required String text, bool isTitle=false}) {
    var _style = isTitle ? textStyle(weight: 700, size: 18.0) : textStyle(weight: 400, size: 16.0);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Text(text, style: _style)
    );
  }

  imageBox(dynamic imageUrl) {
    if(imageUrl != null) {
      return GestureDetector(
        onTap: () {
          if(noticeItem['hyperlink'] != null) launch(noticeItem['hyperlink']);
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(imageUrl),
        )
      );
    }
    if(imageUrl == null) return Container();
  }
}
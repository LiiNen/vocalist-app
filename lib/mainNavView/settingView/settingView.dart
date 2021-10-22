import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/mainNavView/settingView/reportView.dart';

import '../../main.dart';
import 'infoView.dart';

class SettingView extends StatefulWidget {
  @override
  State<SettingView> createState() => _SettingView();
}
class _SettingView extends State<SettingView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '더보기'),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 21),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buttonContainer(context: context, callback: _pushNavigatorInfo, title: '계정 관리'),
              buttonContainer(context: context, callback: _pushReport, title: '버그리포트'),
              buttonContainer(context: context, callback: null, title: '버전 정보 조회'),
              buttonContainer(context: context, callback: null, title: '이용 약관'),
              buttonContainer(context: context, callback: null, title: '개인정보 취급 방침')
            ]
          )
        )
      )
    );
  }

  _pushNavigatorInfo() {
    navigatorPush(context: context, widget: InfoView());
  }
  _pushReport() {
    navigatorPush(context: context, widget: ReportView());
  }
}

buttonContainer({required context, required callback, required title, rightItem}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {if(callback != null) callback();},
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          rightItem != null ? rightItem : Container()
        ]
      )
    )
  );
}
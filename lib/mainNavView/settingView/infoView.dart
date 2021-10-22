import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/settingView/settingView.dart';
import 'package:vocalist/mainNavView/settingView/withdrawalView.dart';

import 'nameModifyView.dart';

class InfoView extends StatefulWidget {
  @override
  State<InfoView> createState() => _InfoView();
}
class _InfoView extends State<InfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '계정 관리', back: true,),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 21),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이름'),
              buttonContainer(context: context, callback: _pushNavigatorNameModify, title: userInfo.name),
              Text('연결된 계정'),
              buttonContainer(context: context, callback: null, title: userInfo.email),
              buttonContainer(context: context, callback: _pushNavigatorWithdrawal, title: '회원 탈퇴')
            ]
          )
        )
      )
    );
  }

  _pushNavigatorNameModify() {
    navigatorPush(context: context, widget: NameModifyView());
  }

  _pushNavigatorWithdrawal() {
    navigatorPush(context: context, widget: WithdrawalView());
  }
}
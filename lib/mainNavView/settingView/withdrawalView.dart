import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class WithdrawalView extends StatefulWidget {
  @override
  State<WithdrawalView> createState() => _WithdrawalView();
}
class _WithdrawalView extends State<WithdrawalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '회원 탈퇴', back: true),
      body: Container(
        child: withdrawalButton()
      )
    );
  }

  withdrawalButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        print('탈퇴하기');
      },
      child: Container(
        width: 60, height: 30,
        child: Center(
          child: Text('탈퇴하기')
        )
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/loginView/loginView.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/restApi/userApi.dart';

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
        margin: EdgeInsets.symmetric(horizontal: 21, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            guideBox(),
            withdrawalButton()
          ]
        )
      )
    );
  }

  guideBox() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: Colors.black),
      ),
      child: Text('ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ')
    );
  }

  withdrawalButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        confirmDialog(context: context,
          title: '정말로 탈퇴하시겠습니까?',
          content: '사용자의 모든 정보가 삭제됩니다.\n계속하시겠습니까?',
          firstMessage: '계속', firstAction: withdrawalAction,
          secondMessage: '취소', secondAction: () {Navigator.pop(context);}
        );
      },
      child: Container(
        width: 60, height: 30,
        child: Center(
            child: Text('탈퇴하기')
        )
      )
    );
  }

  withdrawalAction() {
    withdrawalActionAsync();
  }

  withdrawalActionAsync() async {
    var response = await deleteUser(id: userInfo.id);
    if(response != null) {
      final pref = await SharedPreferences.getInstance();
      pref.setBool('isLogin', false);
      pref.remove('userId');
      pref.remove('userName');
      pref.remove('userEmail');
      pref.remove('userType');
      navigatorPush(context: context, widget: LoginView(), replacement: true, all: true);
    }
    else {
      showToast('네트워크 상태를 확인해주세요');
      Navigator.pop(context);
    }
  }
}
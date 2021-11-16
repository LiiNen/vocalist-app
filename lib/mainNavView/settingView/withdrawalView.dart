import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/loginView/loginView.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/restApi/userApi.dart';

class WithdrawalView extends StatefulWidget {
  @override
  State<WithdrawalView> createState() => _WithdrawalView();
}
class _WithdrawalView extends State<WithdrawalView> {
  List<String> _titleList = [
    '지금까지의 회원 데이터가 모두 삭제됩니다.',
    '친구들이 더 이상 ${userInfo.name}님을\n리스트에서 보지 못합니다.',
    'apple 계정의 경우 앱 삭제 후\n재설치 시에만 재가입이 가능합니다.'
  ];
  List<List<String>> _detailList = [
    ['좋아요한 노래', '저장한 플레이리스트 목록', '사용자 음역대 정보 및 기록'],
    ['친구 목록 삭제', '애창곡 리스트 삭제'],
    []
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: '회원 탈퇴', back: true),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 27),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: '${userInfo.name}님의 계정을 ', style: textStyle(color: Color(0xff7c7c7c), weight: 700, size: 18.0)),
                  TextSpan(text: '회원 탈퇴', style: textStyle(color: Color(0xff7156d2), weight: 700, size: 18.0)),
                  TextSpan(text: '합니다.', style: textStyle(color: Color(0xff7c7c7c), weight: 700, size: 18.0)),
                ]
              )
            ),
            SizedBox(height: 40),
            guideBox(title: _titleList[0], detail: _detailList[0]),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15.5),
              child: lineDivider(context: context),
            ),
            guideBox(title: _titleList[1], detail: _detailList[1]),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15.5),
              child: lineDivider(context: context),
            ),
            guideBox(title: _titleList[2], detail: _detailList[2]),
            bottomAlignButton(title: '계정 영구 삭제', callback: withdrawalDialog),
            SizedBox(height: 32),
          ]
        )
      )
    );
  }

  guideBox({required String title, required List<String> detail}) {
    var _detailTextList = List.generate(detail.length, (index) {
      return Container(
        margin: EdgeInsets.only(top: 4),
        child: Text(detail[index], style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 14.0))
      );
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: textStyle(color: Color(0xff7156d2), weight: 500, size: 14.0))
        ] + _detailTextList
      )
    );
  }

  withdrawalDialog() {
    confirmDialog(context: context,
      title: '정말로 탈퇴하시겠습니까?',
      content: '사용자의 모든 정보가 삭제됩니다.\n계속하시겠습니까?',
      firstMessage: '계속', firstAction: withdrawalAction,
      secondMessage: '취소', secondAction: () {Navigator.pop(context);}
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
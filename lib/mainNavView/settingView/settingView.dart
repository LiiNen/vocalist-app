import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/collections/userInfo.dart';
import 'package:vocalist/loginView/loginView.dart';
import 'package:vocalist/mainNavView/settingView/nameModifyView.dart';
import 'package:vocalist/mainNavView/settingView/reportView.dart';
import 'package:vocalist/mainNavView/settingView/withdrawalView.dart';
import 'package:vocalist/restApi/userApi.dart';

import '../../main.dart';

class SettingView extends StatefulWidget {
  @override
  State<SettingView> createState() => _SettingView();
}
class _SettingView extends State<SettingView> {

  TextEditingController _emojiController = TextEditingController();
  String _karaoke = '';
  var _karaokeList = ['TJ', '금영'];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _getKaraoke();
  }

  void _getUserInfo() async {
    var _temp = await getUser(id: userInfo.id);
    if(_temp != null) {
      await setUserInfo(id: _temp['id'], name: _temp['name'], email: _temp['email'], type: _temp['type'], emoji: _temp['emoji']);
      userInfo = await getUserInfo();
      _setEmoji();
      setState(() {});
    }
  }

  void _getKaraoke() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _karaoke = pref.getString('karaoke') ?? 'TJ';
    });
  }

  void _setKaraoke(String _type) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('karaoke', _type);
  }

  void _setEmoji() {
    _emojiController.text = userInfo.emoji != '' ? unicodeToEmoji(userInfo.emoji) : '';
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(title: '더보기'),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 39),
              setEmojiContainer(),
              SizedBox(height: 12),
              Text(userInfo.name, style: textStyle(color: Color(0xff7c7c7c), weight: 700, size: 24.0)),
              SizedBox(height: 15.5),
              lineDivider(context: context),
              _titleBox('계정 / 정보 관리'),
              buttonContainer(context: context, callback: null, title: '연결된 계정', rightItem: Text(userInfo.email, style: textStyle(color: Color(0xffd1d1d1), weight: 400, size: 13.0),)),
              buttonContainer(context: context, callback: _karaokeChange, title: '주이용 노래방', rightItem: Text(_karaoke, style: textStyle(color: Color(0xffd1d1d1), weight: 400, size: 13.0),)),
              buttonContainer(context: context, callback: null, title: '검색 기록 저장', rightItem: Text('ON', style: textStyle(color: Color(0xffd1d1d1), weight: 400, size: 13.0),)),
              // buttonContainer(context: context, callback: null, title: '이용 약관'),
              // buttonContainer(context: context, callback: null, title: '개인정보 취급 방침'),
              SizedBox(height: 3.5),
              lineDivider(context: context),
              _titleBox('기타'),
              buttonContainer(context: context, callback: _versionDialog, title: '버전 정보 조회'),
              buttonContainer(context: context, callback: _pushNavigatorReport, title: '버그리포트'),
              buttonContainer(context: context, callback: _signOutDialog, title: '로그아웃'),
              buttonContainer(context: context, callback: _pushNavigatorWithdrawal, title: '탈퇴하기'),
            ]
          )
        )
      )
    );
  }

  setEmojiContainer() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        navigatorPush(context: context, widget: NameModifyView());
      },
      child: Container(
        width: 170, height: 170,
        child: Stack(
          children: [
            Container(
              width: 170, height: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(85)),
                border: Border.all(color: Color(0xfff0f0f0), width: 1),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _emojiController,
                enabled: false,
                style: textStyle(size: 100.0),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                )
              )
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: Color(0xff4a4a4a),
                  borderRadius: BorderRadius.all(Radius.circular(19)),
                ),
                child: Center(
                  child: Icon(Icons.create_outlined, size: 25, color: Colors.white),
                )
              )
            )
          ]
        )
      )
    );
  }

  _titleBox(String title) {
    return Container(
      margin: EdgeInsets.only(top: 19.5, bottom: 16),
      width: MediaQuery.of(context).size.width,
      child: Text(title, style: textStyle(weight: 700, size: 16.0)),
    );
  }

  _karaokeChange() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 28),
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: List<Widget>.generate(_karaokeList.length, (index) {
                var _selected = (_karaoke == _karaokeList[index]);
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: ((){
                    Navigator.pop(context);
                    _setKaraoke(_karaokeList[index]);
                    setState(() {
                      _karaoke = _karaokeList[index];
                    });
                  }),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            _karaokeList[index],
                            style: _selected
                              ? textStyle(color: Color(0xff0958c5), weight: 700, size: 18.0)
                              : textStyle(color: Colors.black, weight: 600, size: 18.0)
                          ),
                        ),
                        Container(
                          child: _selected ? Container(
                            width: 24, height: 24,
                            margin: EdgeInsets.only(right: 31),
                            child: Icon(Icons.check)
                          ) : Container()
                        )
                      ]
                    )
                  ),
                );
              }),
            ),
          )
        );
      }
    );
  }

  /// todo: version server and build
  _versionDialog() {
    showConfirmDialog(context, ConfirmDialog(
      title: '현재 버전 1.0.2\n최신 버전 1.0.2',
      positiveAction: null,
      negativeAction: null,
      confirmAction: () {},
      positiveWord: '',
      negativeWord: '',
    ));
  }

  _signOutDialog() {
    showConfirmDialog(context, ConfirmDialog(
      title: '로그아웃 하시겠습니까?',
      positiveAction: _signOutAction,
      negativeAction: () {},
      confirmAction: null,
      positiveWord: '계속',
      negativeWord: '취소'
    ));
  }

  _signOutAction() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('isLogin', false);
    pref.remove('userId');
    pref.remove('userName');
    pref.remove('userEmail');
    pref.remove('userType');
    navigatorPush(context: context, widget: LoginView(), replacement: true, all: true);
  }
  _pushNavigatorReport() {
    navigatorPush(context: context, widget: ReportView());
  }
  _pushNavigatorWithdrawal() {
    navigatorPush(context: context, widget: WithdrawalView());
  }
}

buttonContainer({required context, required callback, required title, rightItem}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {if(callback != null) callback();},
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 13.0)),
          rightItem != null ? rightItem : Container()
        ]
      )
    )
  );
}
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/settingView/reportView.dart';
import 'package:vocalist/restApi/userApi.dart';

import '../../main.dart';
import 'infoView.dart';

class SettingView extends StatefulWidget {
  @override
  State<SettingView> createState() => _SettingView();
}
class _SettingView extends State<SettingView> {

  String _karaoke = '';
  var _karaokeList = ['TJ', '금영'];

  @override
  void initState() {
    super.initState();
    _getKaraoke();
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


  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '더보기'),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 21, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(userInfo.name),
              SizedBox(height: 20),
              buttonContainer(context: context, callback: _karaokeChange, title: 'TJ/금영 설정 변경', rightItem: Text(_karaoke)),
              buttonContainer(context: context, callback: _pushNavigatorInfo, title: '계정 관리'),
              buttonContainer(context: context, callback: _pushReport, title: '버그리포트'),
              buttonContainer(context: context, callback: null, title: '버전 정보 조회'),
              buttonContainer(context: context, callback: null, title: '이용 약관'),
              buttonContainer(context: context, callback: _postTest, title: '개인정보 취급 방침'),
              EmojiPicker(
                rows: 3,
                columns: 7,
                buttonMode: ButtonMode.MATERIAL,
                numRecommended: 10,
                onEmojiSelected: (emoji, category) {
                  _postTest(emoji.emoji);
                },
              )
            ]
          )
        )
      )
    );
  }

  _postTest(String emoji) async {
    await postUser(emoji: emoji);
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
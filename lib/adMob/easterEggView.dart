import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/adMob/adMobReward.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';

class EasterEggView extends StatefulWidget {
  @override
  State<EasterEggView> createState() => _EasterEggView();
}
class _EasterEggView extends State<EasterEggView> {
  int? _adCount;

  @override
  void initState() {
    super.initState();
    _getAdCount();
  }

  void _getAdCount() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _adCount = pref.getInt('adCount') ?? 0;
    });
  }

  void _setAdCount() async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt('adCount', _adCount!+1);
    if(_adCount!+1 == 5) {
      setAdIgnore();
      showConfirmDialog(context, ConfirmDialog(
        title: '광고가 보인다면 앱을 재실행해주세요\n감사합니다😃',
        positiveAction: null, negativeAction: null,
        confirmAction: () {},
      ));
    }
    _getAdCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: '이스터에그를 발견하셨습니다!'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: _adCount!=null ? Column(
          children: [
            SizedBox(height: 10),
            Text('더보기 탭의 상단 \'더보기\'를 11회 터치 시'
                '\n본 페이지로 이동됩니다.', style: textStyle(weight: 500, size: 12.0), textAlign: TextAlign.center),
            Expanded(child: Container()),
            Text('반복되고 관심없는 배너 광고, 지겨우셨죠?'
                '\n유료 결제 없이, 광고를 제거해드립니다!'
                '\n더 이상 보기 싫은 광고 OUT!', style: textStyle(weight: 700, size: 16.0), textAlign: TextAlign.center),
            Expanded(child: Container()),
            _descriptionBox(),
            additionalButton(title: !isAdIgnore ? '불쌍한 개발자를 위해 광고보기' : '광고... 더 봐주실래요?', callback: _adWatch, width: 140.0, height: 30.0),
            SizedBox(height: 5),
            _adCountBox(),
            SizedBox(height: 40),
          ]
        ) : Container()
      )
    );
  }

  _descriptionBox() {
    return Container(
      child: Column(
        children: [
          Text(!isAdIgnore
            ? '아래의 광고보기를 5회 이상 진행하실 경우\n앱 내의 모든 배너 광고가 사라집니다.'
            : '모든 배너 광고가 제거되었습니다!\n😃감사합니다😃',
            style: textStyle(weight: 600, size: 11.0), textAlign: TextAlign.center),
          SizedBox(height: 10),
        ],
      )
    );
  }

  _adCountBox() {
    return Text('현재 광고 시청 횟수: ${_adCount!} / 5회',
      style: textStyle(weight: 600, size: 12.0));
  }

  _adWatch() async {
    showAdMobRewarded(callback: _setAdCount);
  }
}
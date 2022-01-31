import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/musicApi.dart';
import 'package:vocalist/restApi/versionApi.dart';

import '../../main.dart';

class ChartView extends StatefulWidget {
  @override
  State<ChartView> createState() => _ChartView();
}
class _ChartView extends State<ChartView> {

  var _chartList = [];
  dynamic _chartVersion;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getChart();
  }

  _getChart() async {
    var _temp = await getChart(userId: userInfo.id);
    _chartVersion = await getVersionChart();
    if(_temp != null) {
      setState(() {
        _chartList = _temp;
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(title: '인기차트'),
      body: _isLoaded ? Column(
        children: [
          _chartVersion != null ? chartVersionBox() : Container(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MusicListContainer(musicList: _chartList, fromFront: true)
                ]
              )
            )
          )
        ]
      ): Container()
    );
  }

  chartVersionBox() {
    var dateYearMonthDay = _chartVersion.split('/');
    var date = '${dateYearMonthDay[0]}년 ${dateYearMonthDay[1]}월 ${dateYearMonthDay[2]}일 TJ 노래방 인기차트입니다.';
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(date, style: textStyle(weight: 600, size: 16.0))
      )
    );
  }
}
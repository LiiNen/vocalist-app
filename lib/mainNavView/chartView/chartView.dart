import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/musicApi.dart';

import '../../main.dart';

class ChartView extends StatefulWidget {
  @override
  State<ChartView> createState() => _ChartView();
}
class _ChartView extends State<ChartView> {

  var _chartList = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getChart();
  }

  _getChart() async {
    var _temp = await getChart(userId: userInfo.id);
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
      body: _isLoaded ? SingleChildScrollView(
        child: Column(
          children: [
            MusicListContainer(musicList: _chartList)
          ]
        )
      ) : Container()
    );
  }
}
import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/curationItemApi.dart';
import 'package:vocalist/restApi/musicApi.dart';

import '../../main.dart';

class RecResultView extends StatefulWidget {
  final String title;
  final int cluster;
  final int curationId;
  final String curationContent;
  RecResultView({required this.title, this.cluster=-1, this.curationId=-1, this.curationContent=''});

  @override
  State<RecResultView> createState() => _RecResultView(title, cluster, curationId, curationContent);
}
class _RecResultView extends State<RecResultView> {
  String title;
  int cluster;
  int curationId;
  String curationContent;
  _RecResultView(this.title, this.cluster, this.curationId, this.curationContent);

  var _musicList = [];
  var _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if(cluster != -1) _getRecMusicCluster();
    if(curationId != -1) _getRecMusicCuration();
  }

  _getRecMusicCluster() async {
    var temp = await getRecMusicCluster(userId: userInfo.id, cluster: cluster);
    if(temp != null) {
      _musicList = temp;
      setState(() {
        _isLoaded = true;
      });
    }
  }

  _getRecMusicCuration() async {
    var temp = await getCurationItem(userId: userInfo.id, curationId: curationId);
    if(temp != null) {
      _musicList = temp;
      setState(() {
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: title, back: true),
      body: _isLoaded ? SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              curationContent != '' ? curationContentBox() : Container(),
              MusicListContainer(musicList: _musicList)
            ]
          )
        )
      ) : Container()
    );
  }

  curationContentBox() {
    return Container(
      margin: EdgeInsets.only(left: 23, right: 23, top: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(curationContent, style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 14.0)),
          SizedBox(height: 15),
          lineDivider(context: context),
        ]
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/musicApi.dart';

import '../../main.dart';

class RecResultView extends StatefulWidget {
  final String title;
  final int cluster;
  RecResultView({required this.title, this.cluster=-1, });

  @override
  State<RecResultView> createState() => _RecResultView(title, cluster);
}
class _RecResultView extends State<RecResultView> {
  String title;
  int cluster;
  _RecResultView(this.title, this.cluster);

  var _musicList = [];
  var _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if(cluster != -1) _getRecMusicCluster();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: title, back: true),
      body: _isLoaded ? SingleChildScrollView(
        child: Container(
          child: MusicListContainer(musicList: _musicList)
        )
      ) : Container()
    );
  }
}
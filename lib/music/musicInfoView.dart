import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/restApi/musicApi.dart';

import '../main.dart';

class MusicInfoView extends StatefulWidget {
  final int musicId;
  MusicInfoView({required this.musicId});

  @override
  State<MusicInfoView> createState() => _MusicInfoView(musicId);
}
class _MusicInfoView extends State<MusicInfoView> {
  int musicId;
  _MusicInfoView(this.musicId);

  dynamic _musicInfo;

  @override
  void initState() {
    super.initState();
    _loadMusicInfo();
  }

  void _loadMusicInfo() async {
    var _temp = await getMusic(id: musicId, userId: userInfo.id);
    setState(() {
      _musicInfo = _temp;
      print(_musicInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '상세 결과', back: true,),
    );
  }
}
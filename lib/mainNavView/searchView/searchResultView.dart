import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/curationItemApi.dart';

import '../../main.dart';

class SearchResultView extends StatefulWidget {
  final String input;
  final String type;
  SearchResultView({required this.input, required this.type});

  @override
  State<SearchResultView> createState() => _SearchResultView(input, type);
}
class _SearchResultView extends State<SearchResultView> {
  String input;
  String type;
  _SearchResultView(this.input, this.type);

  var musicList = [];

  @override
  void initState() {
    super.initState();
    _getResult();
  }

  void _getResult() async {
    //todo: change to search result api
    var _temp = await getCurationItem(curationId: 52, userId: userInfo.id, type: 'part');
    setState(() {
      musicList = _temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '검색 결과', back: true),
      body: Container(
        child: Column(
          children: [
            musicList.length != 0 ? MusicListContainer(musicList: musicList) : FlutterLogo(size: 30),
          ]
        )
      )
    );
  }
}
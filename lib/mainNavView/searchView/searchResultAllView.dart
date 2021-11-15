import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/searchApi.dart';

import '../../main.dart';

class SearchResultAllView extends StatefulWidget {
  final int searchIndex;
  final String input;
  SearchResultAllView({required this.searchIndex, required this.input});

  @override
  State<SearchResultAllView> createState() => _SearchResultAllView(searchIndex, input);
}
class _SearchResultAllView extends State<SearchResultAllView> {
  int searchIndex;
  String input;
  _SearchResultAllView(this.searchIndex, this.input);

  var _musicList;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getMusicList();
  }

  _getMusicList() async {
    if(searchIndex == 1) {
      _musicList = await searchTitle(userId: userInfo.id, input: input);
    }
    else if(searchIndex == 2) {
      _musicList = await searchArtist(userId: userInfo.id, input: input);
    }
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: '검색 결과 더보기', back: true, search: true),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              _isLoaded && _musicList != null ?
                MusicListContainer(musicList: _musicList, highlight: input, index: searchIndex) :
                Container(),
            ]
          )
        )
      )
    );
  }
}
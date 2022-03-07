import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/music/musicListContainer.dart';

class MusicSuggestionView extends StatefulWidget {
  final dynamic musicList;
  final bool isNew;
  MusicSuggestionView(this.musicList, {this.isNew=false});
  @override
  State<MusicSuggestionView> createState() => _MusicSuggestionView(this.musicList);
}
class _MusicSuggestionView extends State<MusicSuggestionView> {
  dynamic musicList;
  _MusicSuggestionView(this.musicList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: widget.isNew ? '신규 추가곡' : '이런 노래도 있어요!', back: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            descriptionBox(),
            MusicListContainer(musicList: musicList)
          ]
        )
      )
    );
  }

  descriptionBox() {
    return Container(
      margin: EdgeInsets.only(left: 23, right: 23, top: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.isNew ? '새로 추가된 노래에요!\n제보로 추가된 노래 및 신곡 최근 30개를 보여줄게요:)'
              : '이런 노래들도 있어요:)\n눌러서 상세한 노래를 들어보고, 불러봐요!', style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 10.0)),
          SizedBox(height: 15),
          lineDivider(context: context),
        ]
      )
    );
  }
}
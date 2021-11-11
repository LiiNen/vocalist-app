import 'package:flutter/material.dart';
import 'package:vocalist/collections/style.dart';

class HomePlaylistContainer extends StatefulWidget {
  @override
  State<HomePlaylistContainer> createState() => _HomePlaylistContainer();
}
class _HomePlaylistContainer extends State<HomePlaylistContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 14),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 22),
                child: Text('나만을 위한 AI 플레이리스트', style: textStyle(weight: 700, size: 14.0)),
              ),
            ]
          ),
          Container(
            margin: EdgeInsets.only(top: 40, left: 14, right: 14),
            child: lineDivider(context: context)
          )
        ],
      )
    );
  }
}
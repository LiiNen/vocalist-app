import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';

class MusicSuggestionContainer extends StatefulWidget {
  @override
  State<MusicSuggestionContainer> createState() => _MusicSuggestionContainer();
}
class _MusicSuggestionContainer extends State<MusicSuggestionContainer> {

  @override
  void initState() {
    super.initState();
  }

  _getMusicSuggestion() async {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      padding: EdgeInsets.only(top: 29),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text('이런 노래는 어떠세요?', style: textStyle(weight: 700, size: 14.0)),
              ),
              additionalButton(title: '더보기+')
            ]
          ),
          suggestionLine(0),
          suggestionLine(1),
          suggestionLine(2),
          SizedBox(height: 22),
          lineDivider(context: context),
        ],
      )
    );
  }

  suggestionLine(int lineIndex) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        children: [
          suggestionItem(lineIndex*2),
          SizedBox(width: 12),
          suggestionItem(lineIndex*2+1),
        ]
      )
    );
  }

  suggestionItem(int itemIndex) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {

        },
        child: Container(
          height: 49,
          padding: EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0xfff3f5f7)
          ),
          child: Row(
            children: [
              Text('00000', style: textStyle(color: Color(0xff4f3497), weight:500, size: 14.0)),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('skskskskkskskskkskskskkskskksksk', style: textStyle(weight: 500, size: 11.0), overflow: TextOverflow.ellipsis,),
                    SizedBox(height: 3),
                    Text('ssksksk', style: textStyle(color: Color(0xff747474), weight: 400, size: 10.0), overflow: TextOverflow.ellipsis,)
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}
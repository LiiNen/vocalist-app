import 'package:flutter/material.dart';
import 'package:vocalist/collections/style.dart';

class HomeCurationContainer extends StatefulWidget {
  final int typeIndex;
  HomeCurationContainer(this.typeIndex);
  @override
  State<HomeCurationContainer> createState() => _HomeCurationContainer(typeIndex);
}
class _HomeCurationContainer extends State<HomeCurationContainer> {
  int typeIndex;
  _HomeCurationContainer(this.typeIndex);

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
                child: Text('${curationType[typeIndex]}큐레이션', style: textStyle(color: Color(0xff7c7c7c), weight: 700, size: 14.0)),
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

var curationType = ['장르별', '상황별', '무드별'];
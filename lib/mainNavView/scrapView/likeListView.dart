import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class LikeListView extends StatefulWidget {
  @override
  State<LikeListView> createState() => _LikeListView();
}
class _LikeListView extends State<LikeListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '좋아요한 노래 목록', back: true)
    );
  }
}
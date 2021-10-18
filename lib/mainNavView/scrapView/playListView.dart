import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class PlayListView extends StatefulWidget {
  @override
  State<PlayListView> createState() => _PlayListView();
}
class _PlayListView extends State<PlayListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '플레이리스트 목록', back: true),
    );
  }
}
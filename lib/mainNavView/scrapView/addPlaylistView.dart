import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class AddPlaylistView extends StatefulWidget {
  @override
  State<AddPlaylistView> createState() => _AddPlaylistView();
}
class _AddPlaylistView extends State<AddPlaylistView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
      child: Scaffold(
        appBar: MainAppBar(title: '플레이리스트 추가', back: true),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [

              ]
            )
          )
        )
      )
    );
  }
}
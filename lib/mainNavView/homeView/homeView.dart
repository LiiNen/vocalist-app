import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/mainNavView/homeView/homeCurationContainer.dart';
import 'package:vocalist/mainNavView/homeView/homePlaylistContainer.dart';
import 'package:vocalist/mainNavView/homeView/musicSuggestionContainer.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeView();
}
class _HomeView extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(title: '홈'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MusicSuggestionContainer(),
            HomePlaylistContainer(),
            HomeCurationContainer(0),
            HomeCurationContainer(1),
            HomeCurationContainer(2),
          ]
        )
      ),
    );
  }
}
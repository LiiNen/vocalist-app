import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeView();
}
class _HomeView extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '홈')
    );
  }
}
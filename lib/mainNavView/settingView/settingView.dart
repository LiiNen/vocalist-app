import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

import '../../main.dart';

class SettingView extends StatefulWidget {
  @override
  State<SettingView> createState() => _SettingView();
}
class _SettingView extends State<SettingView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '더보기'),
      body: Center(
        child: Text(userInfo.name)
      )
    );
  }
}
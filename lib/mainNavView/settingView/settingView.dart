import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class SettingView extends StatefulWidget {
  @override
  State<SettingView> createState() => _SettingView();
}
class _SettingView extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '더보기')
    );
  }
}
import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class NameModifyView extends StatefulWidget {
  @override
  State<NameModifyView> createState() => _NameModifyView();
}
class _NameModifyView extends State<NameModifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: '이름 변경', back: true)
    );
  }
}
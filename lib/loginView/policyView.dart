import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/restApi/policyApi.dart';

class PolicyView extends StatefulWidget {
  final int index;
  PolicyView(this.index);

  @override
  State<PolicyView> createState() => _PolicyView(index);
}
class _PolicyView extends State<PolicyView> {
  int index;
  _PolicyView(this.index);

  dynamic _policyData;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getPolicy();
  }

  _getPolicy() async {
    var temp = await getPolicy(id: index);
    if(temp == null) {
      showToast('네트워크를 확인해주세요');
    }
    else {
      setState(() {
        _policyData = temp;
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded ? Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: _policyData['title'], back: true),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          width: MediaQuery.of(context).size.width,
          child: Text(_policyData['content'])
        )
      )
    ) : Container();
  }
}
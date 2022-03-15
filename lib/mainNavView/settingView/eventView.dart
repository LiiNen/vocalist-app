import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/restApi/eventApi.dart';

class EventView extends StatefulWidget {
  State<EventView> createState() => _EventView();
}
class _EventView extends State<EventView> {
  TextEditingController _phoneController = TextEditingController();

  String _imgUrl = '';
  int _count = -1;

  bool _isParticipate = false;
  bool _isAdParticipate = false;

  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getEvent();
  }

  _getEvent() async {
    await getEvent();
    await getEventUser(userId: userInfo.id);
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
      child: Scaffold(
        appBar: DefaultAppBar(title: '진행 중인 이벤트'),
        body: _isLoaded ? (_imgUrl!='' ? Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(_imgUrl),
                SizedBox(height: 20),
                interactionContainer()
              ]
            )
          )
        ) : Center(child: Text('진행 중인 이벤트가 없습니다.'))) : Center(child: CircularProgressIndicator())
      )
    );
  }

  interactionContainer() {
    return Column(
      children: [
        postEventButton(),
        SizedBox(height: 20),
        Text('현재 참여 인원: $_count명', style: textStyle())
      ]
    );
  }

  postEventButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(

        ),
        child: Center(
          child: Text('응모하기')
        )
      )
    );
  }

  _postEvent() async {
    await postEventUser(userId: userInfo.id, phone: _phoneController.text);
    await _getEvent();
  }
}
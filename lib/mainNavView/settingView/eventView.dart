import 'package:flutter/material.dart';
import 'package:vocalist/adMob/adMobReward.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/restApi/eventApi.dart';

class EventView extends StatefulWidget {
  final dynamic eventInfo;
  EventView({required this.eventInfo});

  State<EventView> createState() => _EventView();
}
class _EventView extends State<EventView> {
  TextEditingController _phoneController = TextEditingController();

  int _count = -1;

  bool _isParticipate = false;
  String _phone = '';
  int _userCount = -1;

  bool _isEventUserLoaded = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _count = widget.eventInfo['count'];
    });
    _getEventCount();
    _getEventUser();
  }

  _getEventCount() async {
    var _temp = await getEvent();
    if(_temp != null) {
      setState(() {
        _count = _temp['count'];
      });
    }
  }

  _getEventUser() async {
    var _temp = await getEventUser(userId: userInfo.id);
    if(_temp != null) {
      setState(() {
        _isParticipate = _temp['participate'] == 1;
        _phone = _temp['phone'];
        _userCount = _temp['participate'] + _temp['ad_participate'];
        if(_phone != '') {
          _phoneController.text = _phone;
        }
        _isEventUserLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom==0.0 // keyboard not shown
              ? 0
              : MediaQuery.of(context).viewInsets.bottom + 100
            ),
            child: Image.network(
              widget.eventInfo['img_url'],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.contain,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: DefaultAppBar(title: 'VLOOM ?????? ?????????!', color: Colors.transparent),
            body: _isEventUserLoaded ? (widget.eventInfo['img_url']!='' ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: interactionContainer()
            ) : Center(child: Text('?????? ?????? ???????????? ????????????.'))) : Center(child: CircularProgressIndicator())
          )
        ]
      )
    );
  }

  interactionContainer() {
    return Column(
      children: [
        Expanded(child: Container()),
        phoneTextField(),
        SizedBox(height: 5),
        Text('???????????? ????????? ???????????? ????????? ???????????? ??????/????????????,\n????????? ?????? ???????????? ???????????????????????? ?????? ???????????????.', style: textStyle(weight: 700, size: 12.0)),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              postEventButton(_postEvent, '????????????', _isParticipate),
              postEventButton(_postEventAd, '????????????\n?????? ????????????', false),
            ]
          )
        ),
        SizedBox(height: 5),
        Text('?????? ?????? ??????: $_count???', style: textStyle(weight: 700)),
        Text('??? ?????? ??????: $_userCount???', style: textStyle(weight: 700)),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom==0.0 ? 60 : 20),
      ]
    );
  }

  postEventButton(dynamic callback, String title, bool isComplete) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(!isComplete) {
          callback(_phoneController.text);
        }
      },
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Color(0xff8b63ff), width: 1),
          color: isComplete ? Color(0xff8b63ff) : Colors.white,
        ),
        child: Center(
          child: !isComplete ?
          Text(title, style: textStyle(color: Color(0xff8b63ff), weight: 600, size: 12.0), textAlign: TextAlign.center,) :
          Text('????????????!', style: textStyle(color: Colors.white, weight: 600, size: 12.0))
        )
      )
    );
  }

  _postEvent(String _phone) async {
    if(_phone.length != 11) {
      showToast('????????? ????????? ??????????????????');
    }
    else {
      var _savedPhoneNum = _phone.substring(0, 3) + '-' + _phone.substring(3, 7) + '-' + _phone.substring(7, 11);
      var _temp = await postEventUser(userId: userInfo.id, phone: _savedPhoneNum);
      if(_temp != null) {
        setState(() {
          _isEventUserLoaded = false;
          _phone = _savedPhoneNum;
        });
        _getEventCount();
        _getEventUser();
      }
    }
  }

  _postEventAd(String _dummy) async {
    if(_isParticipate == false) {
      showToast('?????? ???????????? ????????????!');
      return;
    }
    else {
      showAdMobRewarded(callback: _adComplete);
    }
  }

  _adComplete() async {
    var _temp = await patchEventUser(userId: userInfo.id, count: _userCount);
    if(_temp != null) {
      setState(() {
        _isEventUserLoaded = false;
      });
      _getEventCount();
      _getEventUser();
    }
  }

  phoneTextField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: 38,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(19)),
          color: Colors.white
        ),
        child: TextField(
          controller: _phoneController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(19)),
              borderSide: BorderSide(color: Color(0xff8b63ff)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(19)),
              borderSide: BorderSide(color: Color(0xff8b63ff)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(19)),
              borderSide: BorderSide(color: Color(0xff8b63ff)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            hintText: _phone=='' ? '????????? ??????(- ?????? ??????)' : _phone,
            hintStyle: textStyle(color: Color(0xff8a8a8a), weight: 400, size: 12.0),
            counterText: '',
          ),
          keyboardType: TextInputType.number,
          style: textStyle(color: Colors.black, weight: 600, size: 12.0, spacing: 2),
          maxLength: 11,
          textAlign: TextAlign.center,
          onChanged: (value) => {setState(() {})},
          onSubmitted: (value) => {setState(() {_postEvent(_phoneController.text);})},
          enabled: _phone == '',
        )
      )
    );
  }
}

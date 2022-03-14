import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/restApi/friendApi.dart';

class UserListContainer extends StatefulWidget {
  final userList;
  final String searchType;
  UserListContainer({required this.userList, required this.searchType});

  @override
  State<UserListContainer> createState() => _UserListContainer();
}
class _UserListContainer extends State<UserListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text('${widget.searchType} 검색 결과', style: textStyle(weight: 700, size: 19.0))
        ),
        SizedBox(height: 14),
        lineDivider(context: context, color: Color(0xffa89bda))
      ] + (widget.userList.length != 0 ? List.generate(widget.userList.length, (index) {
        var _user = widget.userList[index];
        return userItemContainer(_user);
      }) : [
        SizedBox(height: 20),
        Text('검색 결과가 없습니다.', style: textStyle(color: Color(0xff7c7c7c), weight: 400, size: 13.0))
      ])
    );
  }

  userItemContainer(user) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 68,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          userEmojiBox(user['emoji']),
          SizedBox(width: 6),
          userInfoBox(user),
          SizedBox(width: 6),
          additionalButton(title: user['type'], isOpposite: user['type']=='google', width: 40.0, height: 16.0),
          SizedBox(width: 6),
          addFriendButton(user),
        ]
      )
    );
  }

  userEmojiBox(String emoji) {
    return Container(
      child: Container(
        width: 28, height: 28,
        child: Center(child: Text(emoji, style: textStyle(size: 24)))
      )
    );
  }

  userInfoBox(user) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(user['name'], overflow: TextOverflow.ellipsis,),
          SizedBox(height: 4),
          Text(user['email'], overflow: TextOverflow.ellipsis),
        ]
      )
    );
  }

  addFriendButton(user) {
    return GestureDetector(
      onTap: () {
        user['is_friend']==0 ? addFriendDialog(user) : showToast('이미 친구입니다!');
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 28, height: 28,
        child: Center(
          child: user['is_friend']==0 ?
            Icon(Icons.person_add_alt_1_outlined, size: 24, color: Color(0xff7c7c7c)) :
            Icon(Icons.person, size: 24, color: Color(0xff5642a0))
        )
      )
    );
  }

  addFriendDialog(user) {
    showConfirmDialog(context, ConfirmDialog(
      title: '${user['name']}님에게\n친구요청을 보내시겠습니까?',
      positiveAction: () {addFriendAction(user['email']);},
      negativeAction: () {},
      confirmAction: null,
      positiveWord: '네',
      negativeWord: '아니요',
    ));
  }

  addFriendAction(userEmail) async {
    var response = await postFriend(userId: userInfo.id, email: userEmail);
    if(response == true) {
      showToast('친구 요청 완료!');
    }
    else {
      showToast('네트워크를 확인해주세요.');
    }
  }
}
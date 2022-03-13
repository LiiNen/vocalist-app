import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/restApi/friendApi.dart';

class UserListContainer extends StatefulWidget {
  final userList;
  UserListContainer({required this.userList});

  @override
  State<UserListContainer> createState() => _UserListContainer();
}
class _UserListContainer extends State<UserListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.userList.length, (index) {
        var _user = widget.userList[index];
        return userItemContainer(_user);
      })
    );
  }

  userItemContainer(user) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 28,
      child: Row(
        children: [
          userEmojiBox(user['emoji']),
          userInfoBox(user),
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
        children: [
          Row(
            children: [
              Expanded(child: Text(user['name'], overflow: TextOverflow.ellipsis,)),
              SizedBox(width: 20),
              Text(user['type']),
            ]
          ),
          Text(user['email']),
        ]
      )
    );
  }

  addFriendButton(user) {
    return GestureDetector(
      onTap: () {
        addFriendDialog(user);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 28, height: 28,
        child: Center(
          child: Icon(Icons.person_add_alt_1_outlined, size: 24, color: Color(0xff5642a0))
        )
      )
    );
  }

  addFriendDialog(user) {
    showConfirmDialog(context, ConfirmDialog(
      title: '${user['name']}님에게\n친구요청을 보내시겠습니까?',
      positiveAction: addFriendAction(user['email']),
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
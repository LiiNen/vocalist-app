import 'package:flutter/material.dart';
import 'package:vocalist/collections/style.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  MainAppBar({this.title}) : preferredSize = Size.fromHeight(44.0);
  @override
  final Size preferredSize;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Container(
        child: Row(
          children: [
            Text(title != null ? title! : 'vloom', style: textStyle(weight: 700, size: 24.0)),
          ]
        )
      ),
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final bool back;
  final bool search;
  final dynamic actionButton;
  DefaultAppBar({required this.title, this.back=false, this.search=false, this.actionButton}) : preferredSize = Size.fromHeight(44.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Container(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            search ? searchBackButton(context) : backButton(context),
            Expanded(child: Text(title, style: textStyle(color: Colors.black, weight: 700, size: 15.0), overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,)),
            actionButton == null ? SizedBox(width: 32) : actionButton
          ]
        )
      )
    );
  }
}

class ConfirmDialog extends StatefulWidget {
  final String title;
  final dynamic positiveAction;
  final dynamic negativeAction;
  final dynamic confirmAction;
  final String? positiveWord;
  final String? negativeWord;
  final RichText? spanTitle;
  ConfirmDialog({required this.title, required this.positiveAction, required this.negativeAction, this.confirmAction, this.positiveWord, this.negativeWord, this.spanTitle});

  @override
  State<ConfirmDialog> createState() => _ConfirmDialog(title: title, positiveAction: positiveAction, negativeAction: negativeAction, confirmAction: confirmAction, positiveWord: positiveWord, negativeWord: negativeWord, spanTitle: spanTitle);
}

class _ConfirmDialog extends State<ConfirmDialog> {
  String title;
  dynamic positiveAction;
  dynamic negativeAction;
  dynamic confirmAction;
  String? positiveWord;
  String? negativeWord;
  RichText? spanTitle;
  _ConfirmDialog({required this.title, required this.positiveAction, required this.negativeAction, this.confirmAction, this.positiveWord, required this.negativeWord, required this.spanTitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: dialogBox()
    );
  }

  dialogBox() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          dialogTitle(),
          dialogSelection(),
        ]
      )
    );
  }

  dialogTitle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22),
      height: 112,
      child: spanTitle != null ? Align(
        alignment: Alignment.centerLeft,
        child: spanTitle,
      ) : Center(
        child: Text(title, style: textStyle(weight: 400, size: 16.0))
      )
    );
  }

  dialogSelection() {
    return Container(
      height: 52,
      child: Row(
        children: confirmAction == null ? [
          selectionBox(positiveWord == null ? '네' : positiveWord!, positiveAction, true),
          selectionBox(negativeWord == null ? '아니요' : negativeWord!, negativeAction, false),
        ] : [
          selectionBox('확인', confirmAction, true),
        ],
      )
    );
  }

  selectionBox(String title, dynamic action, bool isPositive) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          action();
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffebebeb), width: 1),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
            color: Color(0xfffbfbfb),
          ),
          child: Center(
            child: Text(title, style: textStyle(color: isPositive ? Color(0xff7156d2) : Color(0xff707070), weight: 600, size: 14.0))
          )
        )
      )
    );
  }
}

backButton(BuildContext context) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {Navigator.pop(context);},
    child: Container(
      width: 32,
      height: 32,
      child: Center(
        child: Icon(Icons.arrow_back, color: Colors.black)
      )
    )
  );
}

searchBackButton(BuildContext context) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      // navigatorPush(context: context, widget: MainNavView(selectedIndex: 3), replacement: true, all: true);
      Navigator.popAndPushNamed(context, '/search');
    },
    child: Container(
      width: 32,
      height: 32,
      child: Center(
        child: Icon(Icons.arrow_back, color: Colors.black)
      )
    )
  );
}

additionalButton({required String title, dynamic callback, bool isOpposite=false, width=48.0}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {if(callback != null) callback();},
    child: Container(
      width: width, height: 21,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(11)),
        border: Border.all(color: Color(0xff8b63ff), width: 1),
        color: !isOpposite ? Color(0xff8b63ff) : Colors.white,
      ),
      child: Center(child: Text(title, style: textStyle(color: !isOpposite ? Colors.white : Color(0xff8b63ff), weight: 500, size: 10.0), textAlign: TextAlign.center))
    )
  );
}

confirmButton({required confirmAction}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      confirmAction();
    },
    child: Container(
      width: 62, height: 29,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        color: Color(0xff8b63ff),
      ),
      child: Center(
        child: Text('완료', style: textStyle(color: Colors.white, weight: 500, size: 12.0))
      )
    )
  );
}

bottomAlignButton({required String title, required dynamic callback}) {
  return Expanded(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          callback();
        },
        child: Container(
          height: 53,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            color: Color(0xff8b63ff)
          ),
          child: Center(
              child: Text(title, style: textStyle(color: Colors.white, weight: 500, size: 15.0))
          )
        )
      )
    )
  );
}
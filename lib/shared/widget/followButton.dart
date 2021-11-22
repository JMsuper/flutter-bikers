import 'package:bikers/api/firstpage/feedApi.dart';
import 'package:bikers/api/user/userApi.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({Key? key, required this.thisUser, required this.item})
      : super(key: key);

  // 앱을 사용하고 있는 본인의 정보
  final dynamic thisUser;
  // 게시글 혹은 타인의 유저 ID
  final Feed item;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  Future follow(BuildContext context) async {
    final isOk = await showOkCancelAlertDialog(
      context: context,
      title: "Follow",
      message: "팔로우 하시겠습니까?",
    );
    if (isOk == OkCancelResult.ok) {
      bool isExist = await UserApi.postFollower(
          toUser: widget.item.writerId, fromUser: widget.thisUser.uid);
      if (!isExist) {
        showOkAlertDialog(
            context: context, title: "팔로우 실패", message: "이미 팔로우 되어있어 있습니다.");
      } else {
        showOkAlertDialog(
            context: context, title: "팔로우 성공", message: "팔로우 되었습니다.");
      }
    }
  }

  Future unFollow(BuildContext context) async {
    final isOk = await showOkCancelAlertDialog(
      context: context,
      title: "UnFollow",
      message: "팔로우를 취소하시겠습니까?",
    );
    if (isOk == OkCancelResult.ok) {
      await UserApi.deleteFollower(
          toUser: widget.item.writerId, fromUser: widget.thisUser.uid);
      widget.item.isfollower = 0;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.thisUser.uid == widget.item.writerId || widget.item.isfollower == 1) {
      return Container();
    } else {
      return OutlinedButton(
        child: Text('팔로우'),
        style: OutlinedButton.styleFrom(
            primary: Colors.black,
            onSurface: Colors.grey,
            backgroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            minimumSize: Size(60, 15)),
        onPressed: () async {
          await follow(context);
        },
      );
    }
  }
}

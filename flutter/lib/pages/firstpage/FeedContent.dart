import 'package:bikers/api/firstpage/feedApi.dart';
import 'package:bikers/shared/passedTime.dart';
import 'package:bikers/shared/widget/commentButton.dart';
import 'package:bikers/shared/widget/followButton.dart';
import 'package:bikers/shared/widget/likeIcon.dart';
import 'package:bikers/shared/widget/modalBottomSheetTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'commentPage.dart';

class _ContentsTop extends StatelessWidget {
  const _ContentsTop(
      {Key? key,
      required this.user,
      required this.item,
      required this.currentTime})
      : super(key: key);
  final Feed item;
  final DateTime currentTime;
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  item.imageUrl == null
                      ? CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.black,
                          backgroundImage:
                              AssetImage('assets/profileImage.jpg'),
                        )
                      : CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.black,
                          backgroundImage: CachedNetworkImageProvider(
                            item.imageUrl!,
                          ),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.writerNickName,
                          style: GoogleFonts.abel(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                            PassedTime.createPassedTime(
                                currentTime, item.createdDate),
                            style: GoogleFonts.abel(
                                color: Colors.grey,
                                fontWeight: FontWeight.w200,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  item.isfollower == null
                      ? Container()
                      : FollowButton(thisUser: user, item: item)
                ]),
          ),
          IconButton(
            splashRadius: 20,
            iconSize: 20,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    color: Colors.black87,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShowModalBottomSheetTile(text: "신고하기"),
                        // ShowModalBottomSheetTile(text: "관심 없음"),
                        // ShowModalBottomSheetTile(text: "공유하기"),
                        // ShowModalBottomSheetTile(text: "링크 복사"),
                        item.writerId == user.uid
                            ? Container(
                                child: ListTile(
                                  dense: true,
                                  title: Text(
                                    '삭제',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Map<String, String> body = {
                                      "feed_id": item.id.toString()
                                    };
                                    Feed.deleteFeed(body);
                                    if (item.hasImage == 1) {
                                      for (int i = 0;
                                          i < item.imageUrlList!.length;
                                          i++) {
                                        FirebaseStorage.instance
                                            .refFromURL(item.imageUrlList![i])
                                            .delete();
                                      }
                                    }
                                  },
                                ),
                              )
                            : Container(),
                        Container(
                          child: ListTile(
                            dense: true,
                            title: Text(
                              '취소',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                backgroundColor: Colors.white,
              );
            },
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentsBodyImage extends StatelessWidget {
  const _ContentsBodyImage(
      {Key? key, required this.imageUrl, required this.size})
      : super(key: key);
  final imageUrl;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: SizedBox(
      width: size.width,
      height: size.width,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
      ),
    ));
  }
}

class _ContentsBodyText extends StatelessWidget {
  const _ContentsBodyText(
      {Key? key, required this.text, required this.size, required this.style})
      : super(key: key);
  final String text;
  final Size size;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      text,
      expandText: "자세히",
      collapseText: "접기",
      linkStyle: TextStyle(color: Colors.grey, fontSize: 13),
      maxLines: 7,
      style: style,
      animation: true,
    );
  }
}

class Content extends StatelessWidget {
  const Content(
      {Key? key,
      required this.item,
      required this.size,
      required this.currentTime,
      required this.user})
      : super(key: key);

  final Size size;
  final Feed item;
  final DateTime currentTime;
  final dynamic user;

  Future likeFunc(userId, Feed item) async {
    try {
      Map<String, String> body = {
        "user_id": userId,
        "feed_id": item.id.toString()
      };
      await Feed.likeFeed(body);
    } catch (err) {
      print(err);
    }
  }

  Future unlikeFunc(userId, Feed item) async {
    try {
      Map<String, String> body = {
        "user_id": userId,
        "feed_id": item.id.toString()
      };
      await Feed.unlikeFeed(body);
    } catch (err) {
      print(err);
    }
  }

  void routeComment(item) {
    Get.to(() => CommentPage(feedId: item.id));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> urlList = [];
    if (item.imageUrlList != null) {
      urlList = item.imageUrlList!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      children: [
        _ContentsTop(
          user: user,
          item: item,
          currentTime: currentTime,
        ),
        SizedBox(
          height: 5,
        ),
        urlList.length == 0
            ? _ContentsBodyText(
                text: item.contents,
                size: size,
                style: GoogleFonts.abel(color: Colors.white, fontSize: 14))
            : _ContentsBodyImage(
                imageUrl: urlList[0],
                size: size,
              ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Container(
            child: Row(
              children: [
                LikeIcon(
                  user: user,
                  item: item,
                  likeFunc: likeFunc,
                  unlikeFunc: unlikeFunc,
                ),
                CommentButton(item: item, routeFunc: routeComment)
              ],
            ),
          ),
        ),
        urlList.length == 0
            ? Container()
            : RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${item.writerNickName}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    TextSpan(
                      text: ' ${item.contents}',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

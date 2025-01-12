import 'dart:convert';
import 'package:bikers/api/firstpage/feedCommentApi.dart';
import 'package:bikers/authentication/user.dart';
import 'package:bikers/pages/firstpage/childCommentPage.dart';
import 'package:bikers/shared/widget/commentButton.dart';
import 'package:bikers/shared/widget/likeIcon.dart';
import 'package:bikers/shared/widget/modalBottomSheetTile.dart';
import 'package:bikers/shared/passedTime.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final int feedId;

  CommentPage({required this.feedId});

  @override
  State createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  List<FeedComment> _messages = <FeedComment>[];
  final TextEditingController _textController = new TextEditingController();
  late int feedId;
  Users? user;
  late dynamic list;
  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    feedId = widget.feedId;
    user = Provider.of<Users?>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      refreshMessage();
    });
  }

  void refreshMessage() async {
    list = json.decode(await FeedComment.getFeedComment(feedId, user!.uid));
    _messages = [];
    for (int i = 0; i < list.length; i++) {
      _messages.add(FeedComment.fromJson(list[i]));
    }
    currentTime = DateTime.now();
    setState(() {});
  }

  void _handleSubmitted(dynamic body) async {
    _textController.clear();
    await FeedComment.postComment(body);
    refreshMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "댓글 달기",
            style: GoogleFonts.abel(),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_textController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("댓글을 입력해주세요"),
                      duration: Duration(seconds: 1),
                    ));
                  } else {
                    Map<String, dynamic> postData = {
                      "feed_id": feedId.toString(),
                      "writer_id": user!.uid,
                      "contents": _textController.text
                    };
                    _handleSubmitted(postData);
                  }
                }),
          ]),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(5.0),
                reverse: false,
                itemBuilder: (_, int index) => CommentMessage(
                  item: _messages[index],
                  currentTime: currentTime,
                  user: user,
                  textController: _textController,
                ),
                itemCount: _messages.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 0.1,
                  );
                },
              ),
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: BuildTextComposer(
              textController: _textController,
            ),
          )
        ],
      ),
    );
  }
}

class BuildTextComposer extends StatelessWidget {
  const BuildTextComposer({Key? key, required this.textController})
      : super(key: key);
  final textController;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Colors.white),
      child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.black,
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: textController,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.white,
                  maxLength: 200,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.short_text,
                        color: Colors.white,
                      ),
                      labelText: '댓글 달기',
                      labelStyle: GoogleFonts.abel(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        color: Colors.white,
                        iconSize: 20,
                        onPressed: () {
                          textController.clear();
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1))),
                ),
              ),
            ],
          )),
    );
  }
}

class CommentMessage extends StatelessWidget {
  CommentMessage(
      {required this.item,
      required this.currentTime,
      required this.user,
      required this.textController});
  final FeedComment item;
  final DateTime currentTime;
  final dynamic user;
  final TextEditingController textController;

  Future likeFunc(userId, FeedComment item) async {
    try {
      Map<String, String> body = {
        "user_id": userId,
        "feed_comment_id": item.id.toString()
      };
      await FeedComment.like(body);
    } catch (err) {
      print(err);
    }
  }

  Future unlikeFunc(userId, FeedComment item) async {
    try {
      Map<String, String> body = {
        "user_id": userId,
        "feed_comment_id": item.id.toString()
      };
      await FeedComment.unlike(body);
    } catch (err) {
      print(err);
    }
  }

  void routeChildComment(FeedComment item) {
    Get.to(() => ChildCommentPage(feedComment: item));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, right: 5),
            child: item.imageUrl == null
                ? CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.black,
                    backgroundImage: AssetImage('assets/profileImage.jpg'),
                  )
                : CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.black,
                    backgroundImage: CachedNetworkImageProvider(
                      item.imageUrl!,
                    ),
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(item.nickName,
                            style: GoogleFonts.aclonica(color: Colors.white)),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "·  " +
                              PassedTime.createPassedTime(
                                  currentTime, item.createdDate),
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                    IconButton(
                      splashRadius: 20,
                      iconSize: 20,
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              color: Colors.black87,
                              height: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShowModalBottomSheetTile(text: "신고하기"),
                                  ShowModalBottomSheetTile(text: "관심 없음"),
                                  ShowModalBottomSheetTile(text: "공유하기"),
                                  ShowModalBottomSheetTile(text: "링크 복사"),
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
                                      onTap: () {},
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
                Container(
                  child: Text(
                    item.contents,
                    style: GoogleFonts.aclonica(color: Colors.white),
                    maxLines: 10,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Row(
                    children: [
                      LikeIcon(
                          user: user,
                          item: item,
                          likeFunc: likeFunc,
                          unlikeFunc: unlikeFunc),
                      CommentButton(item: item, routeFunc: routeChildComment)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      // item.child != null
      //     ? Flex(
      //         mainAxisSize: MainAxisSize.min,
      //         direction: Axis.vertical,
      //         children: [
      //             ListView.builder(
      //                 shrinkWrap: true,
      //                 physics: NeverScrollableScrollPhysics(),
      //                 itemCount: item.child!.length,
      //                 itemBuilder: (context, index) {
      //                   return ChatSubMessage(
      //                     item: FeedComment.fromJson(item.child![index]),
      //                     currentTime: currentTime,
      //                   );
      //                 }),
      //           ])
      //     : Container()
    );
  }
}

class ChatSubMessage extends StatelessWidget {
  ChatSubMessage({required this.item, required this.currentTime});
  final FeedComment item;
  final DateTime currentTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        SizedBox(width: 10),
        item.imageUrl == null
            ? CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.black,
                backgroundImage: AssetImage('assets/profileImage.jpg'),
              )
            : CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.black,
                backgroundImage: CachedNetworkImageProvider(
                  item.imageUrl!,
                ),
              ),
        SizedBox(width: 5),
        Text(item.nickName, style: GoogleFonts.aclonica(color: Colors.white)),
        SizedBox(
          width: 5,
        ),
        Text(
          PassedTime.createPassedTime(currentTime, item.createdDate),
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            item.contents,
            style: GoogleFonts.aclonica(color: Colors.white),
            maxLines: 10,
            softWrap: true,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

import 'dart:convert';

import 'package:bikers/api/firstpage/feedApi.dart';
import 'package:bikers/api/user/userApi.dart';
import 'package:bikers/authentication/sign_in.dart';
import 'package:bikers/authentication/user.dart';
import 'package:bikers/main.dart';
import 'package:bikers/pages/fourthpage/feedshoptourPage/feedPage.dart';
import 'package:bikers/pages/fourthpage/feedshoptourPage/shopPage.dart';
import 'package:bikers/pages/fourthpage/feedshoptourPage/tourPage.dart';
import 'package:bikers/services/auth.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'settingPage/settingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class FourthApp extends StatefulWidget {
  @override
  _FourthAppState createState() => _FourthAppState();
}

class _FourthAppState extends State<FourthApp> {
  late Users? user;
  final AuthService _auth = AuthService();

  int followCount = 0;
  int followerCount = 0;
  int feedCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await getData();
      setState(() {});
    });
  }

  Future getData() async {
    Map<String, dynamic> followData = await UserApi.getFollowCount(user!.uid);
    followCount = followData["followee_count"];
    followerCount = followData["follower_count"];
    feedCount = await Feed.getFeedCount(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    user = context.read<Users?>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Bikers()));
            },
            child: Text('MY BIKERS',
                style: GoogleFonts.permanentMarker(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white))),
        centerTitle: false,
        backgroundColor: Colors.black,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SettingPage()));
            },
          ),
        ],
      ),
      body: user == null
          ? Container()
          : FutureBuilder(
              future: UserApi.getUserInfo(user!.uid),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  UserApi userInfo =
                      UserApi.fromJson(json.decode(snapshot.data));
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundImage: AssetImage(
                                            "assets/profileImage.jpg"),
                                        backgroundColor: Colors.black,
                                      ),
                                      Positioned(
                                        bottom: -3,
                                        right: -5,
                                        child: ClipOval(
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            alignment: Alignment.center,
                                            color: Colors.black,
                                            child: IconButton(
                                                iconSize: 15,
                                                splashRadius: 10,
                                                onPressed: () {},
                                                icon: Icon(Icons.edit,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${userInfo.nickName}',
                                          style: GoogleFonts.abel(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ]),
                                ]),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios,
                                      color: Colors.white),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '팔로우     ' + followCount.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  '팔로워     ' + followerCount.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                '게시물     ' + feedCount.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Divider(),
                          // Container(
                          //   width: 300,
                          //                 child: ElevatedButton(
                          //       onPressed: () {},
                          //       child: Text('프로필 편집',
                          //       style: TextStyle(color: Colors.white),)),
                          // ),
                          // Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FeedPage()));
                                      },
                                      icon: Icon(
                                        Icons.picture_in_picture_rounded,
                                        color: Colors.white,
                                      )),
                                  Text('게시물',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShopPage()));
                                      },
                                      icon: Icon(
                                        Icons.shop,
                                        color: Colors.white,
                                      )),
                                  Text('판매글',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TourPage()));
                                      },
                                      icon: Icon(
                                        Icons.tour_outlined,
                                        color: Colors.white,
                                      )),
                                  Text('투어글',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              )
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.password,
                                        color: Colors.white,
                                      )),
                                  Text('본인 인증',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      )),
                                  Text('좋아요한 게시물',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.settings_input_antenna_outlined,
                                        color: Colors.white,
                                      )),
                                  Text('친구 찾기',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.tune,
                                        color: Colors.white,
                                      )),
                                  Text('카테고리',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.tv,
                                        color: Colors.white,
                                      )),
                                  Text('나의 활동',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.qr_code_2_rounded,
                                          color: Colors.blueAccent)),
                                  Text('나의 QR코드',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        await _auth.signOut();
                                        Get.offAll(() => SignIn());
                                      },
                                      icon: Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      )),
                                  Text('로그아웃',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                      )),
                                  Text('설정',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              )
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
    );
  }
}

import 'package:bikers/home/home.dart';
import 'package:bikers/pages/firstpage/allFeedPage.dart';
import 'package:bikers/pages/firstpage/followerFeedPage.dart';
import 'package:bikers/shared/widget/speedDial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'searchpage.dart';

class FirstApp extends StatefulWidget {
  _FirstAppState createState() => _FirstAppState();
}

class _FirstAppState extends State<FirstApp>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);
  late Size size;
  dynamic user;

  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 50,
          title: TextButton(
              onPressed: () {
                Get.offAll(() => Home());
              },
              child: Text('BIKERS FEED',
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
              icon: Icon(Icons.search_rounded),
              onPressed: () {
                showSearch(context: context, delegate: Search(list));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            TabBar(
              tabs: <Tab>[
                Tab(
                  text: 'All',
                ),
                Tab(
                  text: 'Follower',
                ),
              ],
              controller: tabController,
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[AllFeedPage(), FollowerFeedPage()],
                controller: tabController,
              ),
            ),
          ],
        ),
        floatingActionButton: MakeSpeedDial(
          heroTag: "first",
        ));
  }
}

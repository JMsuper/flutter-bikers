import 'package:bikers/pages/firstpage/firstpage.dart';
import 'package:bikers/pages/fourthpage/fourthpage.dart';
import 'package:bikers/pages/secondpage/secondpage.dart';
import 'package:bikers/pages/thirdpage/thirdpage.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // endDrawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       UserAccountsDrawerHeader(
      //         currentAccountPicture: CircleAvatar(
      //           backgroundImage: AssetImage('assets/naked.jpg'),
      //           backgroundColor: Colors.black87,
      //         ),
      //         accountName: Text('Lloyd'),
      //         accountEmail: Text('lloydlee725@naver.com'),
      //         decoration: BoxDecoration(
      //             color: Colors.black87,
      //             borderRadius: BorderRadius.only(
      //                 bottomLeft: Radius.circular(10.0),
      //                 bottomRight: Radius.circular(10.0))),
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.tv,
      //           color: Colors.black,
      //         ),
      //         title: Text('Activity'),
      //         onTap: () {
      //           print('Activity is clicked');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.person_add_alt_1_rounded,
      //           color: Colors.black,
      //         ),
      //         title: Text('Friends'),
      //         onTap: () {
      //           print('Friends is clicked');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.qr_code_2_rounded,
      //           color: Colors.black,
      //         ),
      //         title: Text('MyQRcode'),
      //         onTap: () {
      //           print('MyQRcode is clicked');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.settings,
      //           color: Colors.black,
      //         ),
      //         title: Text('Settings'),
      //         onTap: () {
      //           print('Settings is clicked');
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: TabBarView(
        children: <Widget>[
          FirstApp(),
          SecondApp(),
          ThirdApp(),
          FourthApp()
        ],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(
        indicatorColor: Colors.blueAccent,
        tabs: <Tab>[
          Tab(
            height: 70,
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.shop_2_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.tour,
              color: Colors.white,
              size: 30,
            ),
          ),      
          Tab(
            icon: Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
        controller: controller,
      ),
    );
  }
}

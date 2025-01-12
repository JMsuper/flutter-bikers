// import 'package:bikers/authentication/register.dart';
import 'package:bikers/authentication/sign_in.dart';
import 'package:bikers/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Setting Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/naked.jpg'),
              backgroundColor: Colors.black87,
            ),
            accountName: Text('Lloyd'),
            accountEmail: Text('#73182738'),
            decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
          ),
          ListTile(
            leading: Icon(Icons.password, color: Colors.white),
            title: Text('본인 인증', style: TextStyle(color: Colors.white)),
            onTap: () {
              print('Activity is clicked');
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.pink),
            title: Text('좋아요한 게시물', style: TextStyle(color: Colors.white)),
            onTap: () {
              print('Activity is clicked');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_input_antenna_outlined,
                color: Colors.white),
            title: Text('친구 찾기', style: TextStyle(color: Colors.white)),
            onTap: () {
              print('Activity is clicked');
            },
          ),
          ListTile(
            leading: Icon(Icons.tune, color: Colors.white),
            title: Text('카테고리', style: TextStyle(color: Colors.white)),
            onTap: () {
              print('Activity is clicked');
            },
          ),
          ListTile(
            leading: Icon(Icons.tv, color: Colors.white),
            title: Text('나의 활동', style: TextStyle(color: Colors.white)),
            onTap: () {
              print('Activity is clicked');
            },
          ),
          ListTile(
            leading: Icon(Icons.qr_code_2_rounded, color: Colors.white),
            title: Text('나의 QR코드', style: TextStyle(color: Colors.white)),
            onTap: () {
              print('MyQRcode is clicked');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('로그아웃', style: TextStyle(color: Colors.white)),
            onTap: () async {
                                        await _auth.signOut();
                                        Get.offAll(()=>SignIn());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('회원탈퇴', style: TextStyle(color: Colors.white)),
            onTap: () {
              _auth.deleteAccount();
              Get.offAll(()=>SignIn());
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('설정', style: TextStyle(color: Colors.white)),
            onTap: () {
              print('Settings is clicked');
            },
          ),
        ],
      ),
    );
  }
}

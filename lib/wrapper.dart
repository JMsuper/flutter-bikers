import 'package:bikers/api/user/userApi.dart';
import 'package:bikers/authentication/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication/user.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    if (user == null) {
      return SignIn();
    } else {
      return FutureBuilder(
        future: UserApi.getUserInfo(user.uid),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data == "") {
            return SignIn();
          } else {
            print(user.uid);
            return Home();
          }
        },
      );
    }
  }
}

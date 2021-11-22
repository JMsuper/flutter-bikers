import 'package:bikers/api/user/userApi.dart';
import 'package:bikers/authentication/sign_up.dart';
import 'package:bikers/authentication/user.dart';
import 'package:bikers/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFromFirebaseUser(User? user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Users?> get user {
    return _auth
        .authStateChanges()
        // .map((User user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in with Phone Number

  Future registerUser(String phone, BuildContext context) async {
    final TextEditingController _codeController = TextEditingController();
    final errorMsgController = Get.put(ErrorMsgController());
    //code
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential authCredential) {
          _auth
              .signInWithCredential(authCredential)
              .then((UserCredential userCredential) {
            if (userCredential.additionalUserInfo!.isNewUser) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUp(
                            mobileNumber: phone,
                            uid: userCredential.user!.uid,
                          )));
            } else {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            }
          }).catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          //print(authException.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          final pinputFocusNode = FocusNode();
          final BoxDecoration pinPutDecoration = BoxDecoration(
              color: const Color.fromRGBO(43, 46, 66, 1),
              border: Border.all(
                color: const Color.fromRGBO(126, 203, 224, 1),
              ),
              shape: BoxShape.rectangle);

          //show dialog to take input from the user
          showDialog(
            useSafeArea: true,
            context: context,
            barrierDismissible: false,
            builder: (context) => SafeArea(
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(10),
                  title: Center(
                      child: Text(
                    "SNS 인증 코드를 입력하세요.",
                    style: TextStyle(fontSize: 15),
                  )),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    PinPut(
                      mainAxisSize: MainAxisSize.min,
                      fieldsCount: 6,
                      withCursor: true,
                      textStyle:
                          const TextStyle(fontSize: 20.0, color: Colors.white),
                      eachFieldWidth: 20.0,
                      eachFieldHeight: 20.0,
                      eachFieldAlignment: Alignment.center,
                      eachFieldMargin: EdgeInsets.all(1),
                      onChanged: (_) {
                        
                      },
                      onSubmit: (String smsCode) async {
                        FirebaseAuth auth = FirebaseAuth.instance;

                        String smsCode = _codeController.text.trim();

                        PhoneAuthCredential authCredential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: smsCode);
                        auth
                            .signInWithCredential(authCredential)
                            .then((UserCredential userCredential) async {
                          if (userCredential.additionalUserInfo!.isNewUser) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp(
                                          mobileNumber: phone,
                                          uid: userCredential.user!.uid,
                                        )));
                          } else {
                            var userInfo = await UserApi.getUserInfo(
                                userCredential.user!.uid);
                            if (userInfo == null || userInfo == "") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp(
                                            mobileNumber: phone,
                                            uid: userCredential.user!.uid,
                                          )));
                            } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                  (route) => false);
                            }
                          }
                        }).catchError((e) {
                          print(e);
                          errorMsgController.changeErrorMsgToError();
                        });
                      },
                      focusNode: pinputFocusNode,
                      controller: _codeController,
                      submittedFieldDecoration: pinPutDecoration,
                      selectedFieldDecoration: pinPutDecoration,
                      followingFieldDecoration: pinPutDecoration,
                      pinAnimationType: PinAnimationType.fade,
                      keyboardType: TextInputType.number,
                    ),
                    GetBuilder<ErrorMsgController>(
                        builder: (_) => Text(
                              _.errorMsg,
                              style: TextStyle(color: Colors.red, fontSize: 13),
                            )),
                  ]),
                );
              }),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timout");
        });
  }

  // deleting a user
  Future deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

class ErrorMsgController extends GetxController {
  String errorMsg = "";

  void changeErrorMsgToError() {
    errorMsg = "잘못된 번호입니다.";
    update();
  }

  void changeErrorMsgToComplete() {
    errorMsg = "";
    update();
  }
}

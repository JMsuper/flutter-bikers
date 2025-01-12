// import 'package:bikers/home/home.dart';
// import 'package:bikers/shared/loading.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pinput/pin_put/pin_put.dart';

// class OTP extends StatefulWidget {
//   final String phone;
//   OTP(this.phone);

//   @override
//   _OTPState createState() => _OTPState();
// }

// class _OTPState extends State<OTP> {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _pinPutController = TextEditingController();
//   final _pinPutFocusNode = FocusNode();
//   final BoxDecoration pinPutDecoration = BoxDecoration(
//     color: const Color.fromRGBO(43, 46, 66, 1),
//     borderRadius: BorderRadius.circular(10.0),
//     border: Border.all(
//       color: const Color.fromRGBO(126, 203, 224, 1),
//     ),
//   );
//   bool loading = false;
//   final GlobalKey _formKeyOTP = GlobalKey<FormState>();
//   String phoneNumber = '';
//   var verificationCode = '';
//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? Loading()
//         : Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               title: Text('인증 센터'),
//             ),
//             body: Form(
//               key: _formKeyOTP,
//               child: Column(
//                 children: [
//                   Container(
//                     color: Colors.white,
//                     margin: EdgeInsets.only(top: 40),
//                     child: Center(
//                       child: Text(
//                         'Verify +1 -${widget.phone}',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 25),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(30.0),
//                     child: PinPut(
//                       fieldsCount: 6,
//                       withCursor: true,
//                       textStyle:
//                           const TextStyle(fontSize: 25.0, color: Colors.white),
//                       eachFieldWidth: 40.0,
//                       eachFieldHeight: 55.0,
//                       onSubmit: (String smsCode) async {
//                         _verifyPhone();
//                         _showSnackBar(smsCode);
//                       },
//                       focusNode: _pinPutFocusNode,
//                       controller: _pinPutController,
//                       submittedFieldDecoration: pinPutDecoration,
//                       selectedFieldDecoration: pinPutDecoration,
//                       followingFieldDecoration: pinPutDecoration,
//                       pinAnimationType: PinAnimationType.fade,
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter OTP';
//                         }
//                       },
//                       onChanged: (value) {
//                         setState(() {
//                           phoneNumber = value;
//                         });
//                       },
//                     ),
//                   ),
//                   Container(
//                     child: TextButton(
//                       child: Text(
//                         '제출',
//                         style: TextStyle(fontSize: 30),
//                       ),
//                       onPressed: () async {
//                         setState(() {
//                         });
//                       },
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//   }

//   void _showSnackBar(String smsCode) {
//     final snackBar = SnackBar(
//       duration: const Duration(seconds: 3),
//       content: Container(
//         height: 80.0,
//         child: Center(
//           child: Text(
//             'Pin Submitted. Value: $smsCode',
//             style: const TextStyle(fontSize: 25.0),
//           ),
//         ),
//       ),
//       backgroundColor: Colors.deepPurpleAccent,
//     );
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);
//   }

//   _verifyPhone() async {
//     await _auth.verifyPhoneNumber(
//         phoneNumber: '+1${widget.phone}',
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential).then((value) async {
//             if (value.user != null && loading == true) {
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => Home()),
//                   (route) => false);
//             }
//           });
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           if (e.code == 'invalid-phone-number') {
//             print('The provided phone number is not valid.');
//           }
//         },
//         codeSent: (String verificationId, int? resendToken) async {
//           // Update the UI - wait for the user to enter the SMS code
//           String smsCode = 'xxxxxx';

//           // Create a PhoneAuthCredential with the code
//           PhoneAuthCredential credential = PhoneAuthProvider.credential(
//               verificationId: verificationId, smsCode: smsCode);

//           // Sign the user in (or link) with the credential
//           await _auth.signInWithCredential(credential);
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() {
//             verificationCode = verificationId;
//           });
//         },
//         timeout: const Duration(seconds: 180));
//   }
// }

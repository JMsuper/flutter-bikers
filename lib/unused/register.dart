// import 'package:bikers/services/auth.dart';
// import 'package:bikers/shared/loading.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Register extends StatefulWidget {
//   final Function toggleView;
//   Register({required this.toggleView});

//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   final AuthService _auth = AuthService();
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool loading = false;
//   String email = '';
//   String password = '';
//   String error = '';

//   @override
//   Widget build(BuildContext context) {
//     return loading ? Loading() : Scaffold(
//       backgroundColor: Colors.white,
//        appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         title: Text('BIKERS 가입하기',
//                   style: GoogleFonts.permanentMarker(
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 2,
//                       color: Colors.black)),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//             padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
//             children: [
//               TextFormField(
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Enter an email';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   setState(() {
//                     email = value;
//                   });
//                 },
//                 controller: emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   hintText: "Email",
//                   icon: Icon(Icons.short_text, color: Colors.black),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.close),
//                     color: Colors.black,
//                     iconSize: 20,
//                     splashRadius: 20,
//                     onPressed: () {
//                       emailController.clear();
//                     },
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.pink)),
//                 ),
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value!.length < 6) {
//                     return 'Enter a password more than 6 characters';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   setState(() {
//                     password = value;
//                   });
//                 },
//                 obscureText: true,
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   icon: Icon(Icons.short_text, color: Colors.black),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.close),
//                     color: Colors.black,
//                     iconSize: 20,
//                     splashRadius: 20,
//                     onPressed: () {
//                       passwordController.clear();
//                     },
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.pink)),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 child: Text(
//                   '가입하기',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.black)),
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     setState(() {
//                       loading = true;
//                     });
//                     dynamic result = await _auth.registerWithEmailAndPassword(
//                         email, password);
//                     if (result == null) {
//                       setState(() {
//                         error = 'please supply a vaild email';
//                         loading = false;
//                       });
//                     }
//                   }
//                 },
//               ),
//               Text(error, style: TextStyle(color: Colors.red, fontSize: 14)),
//               ElevatedButton(
//                 child:
//                     Text('Sign in anon', style: TextStyle(color: Colors.white)),
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.black)),
//                 onPressed: () async {
//                   dynamic result = await _auth.signInAnon();
//                   if (result == null) {
//                     print('error signing in');
//                   } else {
//                     print('signed in');
//                     print(result.uid);
//                   }
//                 },
//               ),
//               TextButton(
//               onPressed: () {
//                 widget.toggleView();
//               },
//               child: Text(
//                 '이미 계정이 있으신가요? 로그인',
//                 style: TextStyle(color: Colors.pink),
//               ))
//             ]),
//       ),
//     );
//   }
// }

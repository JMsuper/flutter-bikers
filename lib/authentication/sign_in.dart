import 'package:bikers/services/auth.dart';
import 'package:bikers/shared/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  bool loading = false;
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1.0,
              title: Text('BIKERS 로그인',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.black)),
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(children: [
                            // Card(
                            //   elevation: 7,
                            //   margin: EdgeInsets.only(
                            //       left: 20, right: 20, top: 10, bottom: 10),
                            //   child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Text('국가선택:',
                            //             style: TextStyle(
                            //                 color: Colors.black,
                            //                 fontWeight: FontWeight.bold)),
                            //         CountryCodePicker(
                            //           onChanged: (c) => c.name,
                            //           initialSelection: 'KR',
                            //           favorite: ['+82', 'KR'],
                            //           showCountryOnly: false,
                            //           showOnlyCountryWhenClosed: true,
                            //           alignLeft: false,
                            //           showFlag: true,
                            //           onInit: (code) => print(
                            //               "on init ${code!.name} ${code.dialCode} ${code.name}"),
                            //         ),
                            //       ]),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '핸드폰 번호를 입력하세요.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  phone = value;
                                });
                              },
                              controller: _phoneController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "핸드폰 번호 (-없이 숫자만 입력)",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.black,
                                  iconSize: 25,
                                  splashRadius: 20,
                                  onPressed: () {
                                    _phoneController.clear();
                                  },
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.pink)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 50,
                              width: 310,
                              child: ElevatedButton(
                                child: Text('인증문자 받기',
                                    //style: TextStyle(fontSize: 20),
                                    style: TextStyle(
                                        fontFamily: 'PermanentMarker',
                                        fontSize: 20)),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _auth.registerUser(
                                        _phoneController.text, context);
                                  }
                                },
                              ),
                            ),
                          ]),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(
                                  '*바이커스는 휴대폰 번호로 회원가입을 진행합니다.\n중고거래 시 실명인증을 위해 필요하며,\n제공된 정보는 다른 이에게 공개되지 않습니다.',
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          );
  }
}

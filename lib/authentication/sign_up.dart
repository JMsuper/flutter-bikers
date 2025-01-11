import 'package:bikers/api/user/userApi.dart';
import 'package:bikers/home/home.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:bikers/shared/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:string_validator/string_validator.dart';

class SignUp extends StatefulWidget {
  final String mobileNumber;
  final String uid;

  SignUp({required this.mobileNumber, required this.uid});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nickNameController = TextEditingController();
  final _birthDayController = TextEditingController();
  final birthMaskFormatter = MaskTextInputFormatter(
      mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')});

  static const String MIN_DATETIME = '2010-01-01 00:00:00';
  static const String MAX_DATETIME = '2050-12-31 23:59:00';

  bool loading = false;
  bool isNickNameDupChecked = false;
  int genderChoice = 0; // 0 : male , 1 : female
  List<String> genderList = ["남자", "여자"];

  Future isNotExistNickName(String nickName) async {
    bool isNotExist = await UserApi.isNotExistedNickName(nickName);
    if (isNotExist == false) {
      Get.defaultDialog(
          title: "중복확인",
          middleText: "중복된 닉네임입니다.",
          backgroundColor: Colors.grey[400],
          textConfirm: "확인",
          confirmTextColor: Colors.black,
          buttonColor: Colors.grey[350],
          onConfirm: () {
            Get.back();
          });
    } else {
      Get.defaultDialog(
          title: "중복확인",
          middleText: "확인되었습니다.",
          backgroundColor: Colors.white,
          textConfirm: "확인",
          confirmTextColor: Colors.black,
          buttonColor: Colors.grey[350],
          onConfirm: () {
            Get.back();
          });
    }
    return isNotExist;
  }

  Future showDatePicker(DateTime _date) async {
    DateTime? birth = await DatePickerBdaya.showDatePicker(
      context,
      minTime: DateTime.parse(MIN_DATETIME),
      maxTime: DateTime.parse(MAX_DATETIME),
      currentTime: _date,
      locale: LocaleType.ko,
    );
    return birth;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1.0,
              title: Text('BIKERS 회원가입',
                  style: GoogleFonts.permanentMarker(
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
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '이름을 입력하세요.';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "이름",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.black,
                                  iconSize: 25,
                                  splashRadius: 20,
                                  onPressed: () {
                                    _nameController.clear();
                                  },
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.pink)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '닉네임을 입력하세요.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                isNickNameDupChecked = false;
                              },
                              maxLength: 15,
                              controller: _nickNameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: "닉네임(2~15자)",
                                  suffixIcon: TextButton(
                                    onPressed: () async {
                                      if (_nickNameController.text.length < 2) {
                                        Get.defaultDialog(
                                            title: "입력오류",
                                            middleText: "2자 이상을 입력해주세요.",
                                            backgroundColor: Colors.white,
                                            textConfirm: "확인",
                                            confirmTextColor: Colors.black,
                                            buttonColor: Colors.grey[350],
                                            onConfirm: () {
                                              Get.back();
                                            });
                                      } else {
                                        isNickNameDupChecked =
                                            await isNotExistNickName(
                                                _nickNameController.text);
                                        print(isNickNameDupChecked);
                                      }
                                    },
                                    child: Text("중복확인"),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.pink)),
                                  counterText: ""),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '생년월일을 입력하세요.';
                                } else if (value.length != 10) {
                                  return '생년월일을 모두 입력하세요.';
                                } else if (!isDate(value)) {
                                  return '올바른 생년월일을 입력하세요.';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                              controller: _birthDayController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [birthMaskFormatter],
                              decoration: InputDecoration(
                                hintText: "생년월일(1997-12-18)",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.black,
                                  iconSize: 25,
                                  splashRadius: 20,
                                  onPressed: () {
                                    _birthDayController.clear();
                                  },
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.pink)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: List<Widget>.generate(
                                2,
                                (int index) {
                                  return ChoiceChip(
                                    label: Text('${genderList[index]}'),
                                    selected: genderChoice == index,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        genderChoice =
                                            selected ? index : genderChoice;
                                      });
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 50,
                              width: 310,
                              child: ElevatedButton(
                                child: Text(
                                  '가입완료',
                                  style: TextStyle(fontSize: 20),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.black),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      isNickNameDupChecked == true) {
                                    try {
                                      await UserApi.save(UserApi.userToMap(
                                          id: widget.uid,
                                          mobileNumber: widget.mobileNumber,
                                          nickName: _nickNameController.text,
                                          name: _nameController.text,
                                          birth: _birthDayController.text,
                                          sex: genderChoice == 0
                                              ? "male"
                                              : "female"));
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()));
                                    } catch (err) {
                                      print(err);
                                    }
                                  } else if (isNickNameDupChecked == false) {
                                    Get.defaultDialog(
                                        title: "중복확인",
                                        middleText: "닉네임 중복확인 해주세요.",
                                        backgroundColor: Colors.white,
                                        textConfirm: "확인",
                                        confirmTextColor: Colors.black,
                                        buttonColor: Colors.grey[350],
                                        onConfirm: () {
                                          Get.back();
                                        });
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

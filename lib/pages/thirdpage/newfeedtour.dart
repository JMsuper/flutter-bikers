import 'dart:async';
import 'package:bikers/authentication/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'chooseLocationPage.dart';
import 'newfeedtourWithGetx.dart';
import 'package:get/get.dart';
import 'package:bikers/api/thirdpage/tourApi.dart';
import 'dart:convert';

class NewFeedTour extends StatefulWidget {
  @override
  _NewFeedTourState createState() => _NewFeedTourState();
}

class _NewFeedTourState extends State<NewFeedTour> {
  final _tourFormKey = GlobalKey<FormState>();
  static const String MIN_DATETIME = '2010-01-01 00:00:00';
  static const String MAX_DATETIME = '2050-12-31 23:59:00';
  String mapUrl =
      "https://flutter-python-623da.web.app/staticMap.html?lat=37.53488514319734&lng=126.9881144036468";
  final Completer<WebViewController> webviewController =
      Completer<WebViewController>();

  EdgeInsets defaultMargin = EdgeInsets.fromLTRB(0, 7, 0, 7);

  final titleController = TextEditingController();
  final textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    textController.dispose();
    Get.delete<DateController>();
    Get.delete<TimeController>();
    Get.delete<MemberController>();
    Get.delete<LocationController>();
  }

  void _showDatePicker(DateTime _date) async {
    DateController.to.changeColor();
    await DatePicker.showDatePicker(
      context,
      minTime: DateTime.parse(MIN_DATETIME),
      maxTime: DateTime.parse(MAX_DATETIME),
      currentTime: _date,
      locale: LocaleType.ko,
      onConfirm: (date) {
        DateController.to.updateDate(date);
      },
    );
    DateController.to.changeColor();
  }

  void _showTimePicker(DateTime _time) async {
    TimeController.to.changeColor();
    await DatePicker.showTime12hPicker(
      context,
      currentTime: _time,
      locale: LocaleType.ko,
      onConfirm: (time) {
        TimeController.to.updateTime(time);
      },
    );
    TimeController.to.changeColor();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DateController());
    Get.put(TimeController());
    Get.put(MemberController());
    Get.put(LocationController());
    final user = Provider.of<Users?>(context);

    return Form(
      key: _tourFormKey,
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: Center(
            child: Text('투어글 올리기',
                style: GoogleFonts.permanentMarker(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          actions: [
            Center(
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: TextButton(
                  child: Text('완료',
                      style: GoogleFonts.abel(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  onPressed: () async {
                    if (_tourFormKey.currentState!.validate()) {
                      String dateTime = DateFormat("yyyy-MM-dd ")
                              .format(DateController.to.date) +
                          DateFormat("hh:mm:ss").format(DateController.to.date);
                      print(dateTime);
                      Map<String, String> dataToMap = Tour.tourDataToMap(
                          writerId: user!.uid,
                          title: titleController.text,
                          contents: textController.text,
                          regionLat: LocationController.to.lat,
                          regionLng: LocationController.to.lng,
                          startDate: dateTime,
                          memberNum: MemberController.to.count.toString());
                      print(json.encode(dataToMap));
                      await Tour.postTour(dataToMap);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '문자를 입력하세요';
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 17, color: Colors.white),
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      maxLength: 30,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: '일정제목',
                          hintStyle: GoogleFonts.abel(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1))),
                    ),
                  ),
                  Container(
                    margin: defaultMargin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('날짜',
                            style: GoogleFonts.abel(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                            // color: Colors.red
                          ),
                          // color: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: InkWell(onTap: () {
                              _showDatePicker(DateController.to.date);
                            }, child: GetBuilder<DateController>(
                              builder: (controller) {
                                return Text(
                                    DateFormat(' yyyy년MM월dd일 ')
                                        .format(controller.date),
                                    style: TextStyle(
                                        color: controller.isChanging
                                            ? Colors.white
                                            : Colors.grey,
                                        fontSize: 15));
                              },
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: defaultMargin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('시간',
                            style: GoogleFonts.abel(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                child: InkWell(onTap: () {
                                  _showTimePicker(TimeController.to.time);
                                }, child: GetBuilder<TimeController>(
                                  builder: (controller) {
                                    return Text(
                                        DateFormat('jm')
                                            .format(controller.time),
                                        style: TextStyle(
                                            color: controller.isChanging
                                                ? Colors.white
                                                : Colors.grey,
                                            fontSize: 15));
                                  },
                                )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: defaultMargin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('인원',
                            style: GoogleFonts.abel(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                            child: InkWell(onTap: () async {
                              MemberController.to.changeColor();

                              showDialog(
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("인원 설정"),
                                      content: Container(
                                          height: 130,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                NumberPicker(
                                                    value: MemberController
                                                        .to.count,
                                                    axis: Axis.horizontal,
                                                    minValue: 5,
                                                    maxValue: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    step: 1,
                                                    haptics: true,
                                                    textStyle:
                                                        TextStyle(fontSize: 18),
                                                    selectedTextStyle:
                                                        TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.blue),
                                                    onChanged: (value) {
                                                      MemberController.to
                                                          .updateCount(value);
                                                    }),
                                                Text(
                                                  "Bikers는 안전상의 이유로 모임인원을 5인 이상으로 제한합니다",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ])),
                                    );
                                  },
                                  context: context);

                              // showModalBottomSheet(
                              //     context: context,
                              //     builder: (context) {
                              //       return Container(
                              //         height: 150,
                              //         child: Column(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceAround,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             children: [
                              //               Text(
                              //                 "인원 설정",
                              //                 style: TextStyle(fontSize: 18),
                              //               ),
                              //               StatefulBuilder(
                              //                   builder: (context, mySetter) {
                              //                 return Center(
                              //                   child: NumberPicker(
                              //                       value: MemberContorller
                              //                           .to.count,
                              //                       axis: Axis.horizontal,
                              //                       minValue: 5,
                              //                       maxValue: 30,
                              //                       decoration: BoxDecoration(
                              //                         borderRadius:
                              //                             BorderRadius.circular(
                              //                                 10),
                              //                         border: Border.all(
                              //                             color: Colors.grey),
                              //                       ),
                              //                       step: 1,
                              //                       haptics: true,
                              //                       textStyle:
                              //                           TextStyle(fontSize: 18),
                              //                       selectedTextStyle:
                              //                           TextStyle(
                              //                               fontSize: 25,
                              //                               color: Colors.blue),
                              //                       onChanged: (value) {
                              //                         mySetter(() {
                              //                           MemberContorller.to
                              //                               .updateCount(value);
                              //                         });
                              //                       }),
                              //                 );
                              //               }),
                              //               Text(
                              //                 "Bikers는 안전상의 이유로 모임인원을 5인 이상으로 제한합니다",
                              //                 style:
                              //                     TextStyle(color: Colors.grey),
                              //               ),
                              //             ]),
                              //       );
                              //     });

                              MemberController.to.changeColor();
                            }, child: GetBuilder<MemberController>(
                              builder: (controller) {
                                return Text("${controller.count}명",
                                    style: TextStyle(
                                        color: controller.isChanging
                                            ? Colors.white
                                            : Colors.grey,
                                        fontSize: 15));
                              },
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      print("Map Click!");
                      List<String>? dataList = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ChooseLocationPage()));
                      if (dataList != null) {
                        for (int i = 0; i < dataList.length; i++) {
                          print(dataList[i]);
                        }
                        webviewController.future.then(
                            (controller) => controller.loadUrl(dataList[0]));
                        LocationController.to.updateLocation(
                            dataList[1], dataList[2], dataList[3]);
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 7, 0, 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey),
                            color: Colors.grey[700]),
                        height: 250,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: AbsorbPointer(
                              child: WebView(
                                initialUrl: mapUrl,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated: (controller) {
                                  webviewController.complete(controller);
                                  // webViewController = controller;
                                },
                              ),
                            ))),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    margin: defaultMargin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('위치: ',
                            style: GoogleFonts.abel(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        GetBuilder<LocationController>(builder: (controller) {
                          return Text('${controller.location}',
                              style: GoogleFonts.abel(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500));
                        })
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '문자를 입력하세요';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        controller: textController,
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.white,
                        maxLength: 400,
                        maxLines: 20,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: '내용',
                          hintStyle: GoogleFonts.abel(
                            fontSize: 15,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 17, 0, 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey[700]),
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

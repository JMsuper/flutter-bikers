import 'package:bikers/pages/firstpage/newfeed.dart';
import 'package:bikers/pages/secondpage/newfeedshopNoBike.dart';
import 'package:bikers/pages/secondpage/newfeedshopWithBike.dart';
import 'package:bikers/pages/thirdpage/newfeedtour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MakeSpeedDial extends StatelessWidget {
  const MakeSpeedDial({Key? key,required this.heroTag}) : super(key: key);
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      curve: Curves.bounceInOut,
      icon: Icons.add,
      activeIcon: Icons.close,
      buttonSize: 45,
      closeManually: false,
      overlayColor: Colors.black87,
      overlayOpacity: 0.5,
      heroTag: heroTag,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      animatedIconTheme: const IconThemeData.fallback(),
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.file_upload),
          label: '피드 올리기',
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NewFeed()));
          },
        ),
        SpeedDialChild(
            child: const Icon(Icons.shop_2_outlined),
            label: '판매글 올리기',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: () {
              Get.defaultDialog(
                  title: "카테고리 선택",
                  content: Container(
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.to(() => NewFeedShopWithBike());
                            },
                            style: TextButton.styleFrom(
                              side: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            child: Text(
                              "바이크",
                              style: GoogleFonts.permanentMarker(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.black),
                            )),
                        TextButton(
                            onPressed: () {
                              Get.to(() => NewFeedShopNoBike());
                            },
                            style: TextButton.styleFrom(
                              side: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            child: Text(
                              "일반용품",
                              style: GoogleFonts.permanentMarker(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.black),
                            )),
                      ],
                    ),
                  ));
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => NewFeedShopNoBike()));
            }),
        SpeedDialChild(
            child: const Icon(Icons.tour),
            label: '투어글 올리기',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NewFeedTour()));
            })
      ],
    );
  }
}
